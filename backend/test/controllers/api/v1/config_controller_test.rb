require "test_helper"

class Api::V1::ConfigControllerTest < ActionDispatch::IntegrationTest
  test "is public and defaults min_supported_build to 0" do
    get "/api/v1/config"
    assert_response :success
    assert_equal({ "min_supported_build" => ENV.fetch("MIN_SUPPORTED_BUILD", 0).to_i }, response.parsed_body)
  end
end
