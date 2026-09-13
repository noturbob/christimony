require "test_helper"

# BaseController#rescue_from turns three exceptions that used to render
# Rails' default HTML error page (with a full stack trace in development)
# into plain JSON. See the class comment on BaseController for why.
class Api::V1::BaseControllerTest < ActionDispatch::IntegrationTest
  def auth_headers_for(account)
    { "Authorization" => "Bearer #{JsonWebToken.encode(account_id: account.id)}" }
  end

  # NOTE: this can't use POST /profiles as the trigger. `config.load_defaults
  # 8.1` turns on `wrap_parameters_by_default`, and ProfilesController's
  # inferred wrap key (`:profile`, from the controller/model name) happens
  # to match exactly what `profile_params` requires -- so a flat body
  # WITHOUT a "profile" key still satisfies `params.require(:profile)` via
  # Rails' auto-wrap, no ParameterMissing raised at all. Verified directly:
  # POST /profiles with a flat {"name": "..."} body returns 201, not 400.
  #
  # ProfilePromptsController doesn't have this safety net: its inferred
  # wrap key is `:profile_prompt` (from the model name `ProfilePrompt`),
  # but the controller explicitly requires `:prompt` -- a different key --
  # so the auto-wrap never satisfies it and a flat body genuinely raises
  # ParameterMissing. This is exactly why the mobile client's `Envelope`
  # enum (mobile/lib/core/network/endpoints.dart) always sends the
  # explicit wrapper rather than relying on any one endpoint's default-wrap
  # behavior, which isn't consistent across endpoints.
  test "a missing envelope key (ActionController::ParameterMissing) renders JSON, not an HTML crash" do
    account = Account.create!(phone: "+919876543210", account_type: "individual", phone_verified_at: Time.current)
    profile = Profile.create!(name: "P", profile_type: "self", status: "active")
    ProfileAccess.create!(account: account, profile: profile, role: "owner")

    # No top-level "prompt" key at all.
    post "/api/v1/profiles/#{profile.id}/prompts",
      params: { question: "Q", answer: "A" }, as: :json, headers: auth_headers_for(account)

    assert_response :bad_request
    assert_equal "application/json; charset=utf-8", response.content_type
    body = JSON.parse(response.body)
    assert_match(/prompt/i, body["error"])
  end

  # ActiveRecord::RecordInvalid and ActiveRecord::RecordNotFound have no
  # existing controller action that raises them on purpose today (every
  # `find_by` call site already guards with an explicit nil check, and
  # every non-bang `.save`/`.create` already branches on success/failure
  # locally) -- these rescue_from entries exist as a safety net for the
  # bang-method call sites that DON'T guard (ProfilesController#create's
  # `ProfileAccess.create!`, InterestsController's mutual-match
  # `Match.create!`/`Introduction.create!`, PhoneAuthController#verify's
  # `account.save!`) and for a future stray `.find`. To exercise the
  # actual rescue_from handlers end-to-end rather than just asserting
  # they're registered, this mounts a throwaway route + controller for
  # the duration of the test.
  test "ActiveRecord::RecordInvalid and RecordNotFound render JSON via the same rescue_from path" do
    with_temporary_test_routes do
      get "/api/v1/__test_only__/not_found"
      assert_response :not_found
      assert_equal({ "error" => "Not found" }, JSON.parse(response.body))

      get "/api/v1/__test_only__/invalid"
      assert_response :unprocessable_entity
      body = JSON.parse(response.body)
      assert body["errors"].present?
    end
  end

  private

  def with_temporary_test_routes
    controller_class = Class.new(Api::V1::BaseController) do
      def not_found
        Profile.find(0)
      end

      def invalid
        Account.create!(account_type: "not_a_real_account_type")
      end
    end
    Object.const_set(:RescueFromTestController, controller_class)

    Rails.application.routes.append do
      get "/api/v1/__test_only__/not_found", to: "rescue_from_test#not_found"
      get "/api/v1/__test_only__/invalid", to: "rescue_from_test#invalid"
    end

    yield
  ensure
    Object.send(:remove_const, :RescueFromTestController) if Object.const_defined?(:RescueFromTestController)
    Rails.application.routes_reloader.reload!
  end
end
