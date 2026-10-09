class AccountChannel < ActionCable::Channel::Base
  def self.notify(profile_ids, event)
    Account.managing(profile_ids).find_each { |account| broadcast_to(account, event) }
  end

  def subscribed
    stream_for current_account
  end
end
