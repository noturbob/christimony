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
end

# ActiveRecord::RecordInvalid and ActiveRecord::RecordNotFound have no
# existing controller action that raises them on purpose today (every
# `find_by` call site already guards with an explicit nil check, and every
# non-bang `.save`/`.create` already branches on success/failure locally)
# -- these rescue_from entries exist as a safety net for the bang-method
# call sites that DON'T guard (ProfilesController#create's
# `ProfileAccess.create!`, InterestsController's mutual-match
# `Match.create!`/`Introduction.create!`, PhoneAuthController#verify's
# `account.save!`) and for a future stray `.find`.
#
# This uses ActionController::TestCase rather than a real request through
# ActionDispatch::IntegrationTest specifically because it gives each test
# class its OWN RouteSet (`@routes`), not the app's shared one -- an
# earlier version of this test mutated Rails.application.routes directly
# to add a throwaway route, and that was flaky under parallel test
# execution (`bin/rails test` runs each file in its own worker process,
# but more than one test in the same file/worker touching the global
# route table at once is exactly the kind of shared mutable state
# parallelization exists to catch you on).
class Api::V1::RescueFromProbeControllerTest < ActionController::TestCase
  tests(Class.new(Api::V1::BaseController) do
    def self.name = "Api::V1::RescueFromProbeController"

    def not_found
      Profile.find(0)
    end

    def invalid
      Account.create!(account_type: "not_a_real_account_type")
    end
  end)

  setup do
    @routes = ActionDispatch::Routing::RouteSet.new.tap do |set|
      set.draw do
        get "not_found" => "api/v1/rescue_from_probe#not_found"
        get "invalid" => "api/v1/rescue_from_probe#invalid"
      end
    end
  end

  test "ActiveRecord::RecordNotFound renders JSON" do
    get :not_found
    assert_response :not_found
    assert_equal({ "error" => "Not found" }, JSON.parse(response.body))
  end

  test "ActiveRecord::RecordInvalid renders JSON" do
    get :invalid
    assert_response :unprocessable_entity
    body = JSON.parse(response.body)
    assert body["errors"].present?
  end
end
