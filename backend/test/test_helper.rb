ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Add more helper methods to be used by all tests here...
    def create_account(account_type: "individual")
      @phone_seq = (@phone_seq || 0) + 1
      Account.create!(phone: "98760#{@phone_seq.to_s.rjust(5, '0')}", account_type: account_type, phone_verified_at: Time.current)
    end

    def create_profile(account, name, role: "owner", status: "active", profile_type: "self")
      profile = Profile.create!(name: name, profile_type: profile_type, status: status)
      ProfileAccess.create!(account: account, profile: profile, role: role)
      profile
    end

    def auth(account)
      { "Authorization" => "Bearer #{JsonWebToken.encode(account_id: account.id)}" }
    end
  end
end
