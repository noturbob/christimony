require "test_helper"

class Api::V1::ProfilePhotosControllerTest < ActionDispatch::IntegrationTest
  PNG = Base64.decode64("iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg==")

  setup do
    @account = create_account
    @profile = create_profile(@account, "Me")
  end

  test "accepts a png" do
    post "/api/v1/profiles/#{@profile.id}/photos", params: { image: upload(PNG, "image/png", "a.png") }, headers: auth(@account)
    assert_response :created
  end

  test "rejects a non-image" do
    post "/api/v1/profiles/#{@profile.id}/photos", params: { image: upload("hello", "text/plain", "a.txt") }, headers: auth(@account)
    assert_response :unprocessable_entity
  end

  test "rejects an image over 10 MB" do
    photo = @profile.profile_photos.new(position: 0)
    photo.image.attach(io: StringIO.new(PNG + ("\0" * 10.megabytes)), filename: "big.png", content_type: "image/png")
    assert_not photo.valid?
    assert_includes photo.errors[:image], "must be 10 MB or smaller"
  end

  private

  def upload(bytes, type, name)
    Rack::Test::UploadedFile.new(StringIO.new(bytes), type, original_filename: name)
  end
end
