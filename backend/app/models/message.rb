class Message < ApplicationRecord
  belongs_to :conversation
  belongs_to :sender_account, class_name: "Account"

  validates :body, presence: true, length: { maximum: 2000 }
  validates :sent_at, presence: true
  validate :sender_has_access_to_conversation

  before_validation :set_sent_at, on: :create
  after_create_commit :notify

  def api_json
    {
      id: id,
      conversation_id: conversation_id,
      sender_account_id: sender_account_id,
      body: body,
      sent_at: sent_at,
      read_at: read_at
    }
  end

  private

  def notify
    profile_ids = [ conversation.profile_a_id, conversation.profile_b_id ]
    AccountChannel.notify(profile_ids, type: "message", message: api_json)

    sender_profile = Profile.where(id: profile_ids).joins(:profile_accesses).find_by(profile_accesses: { account_id: sender_account_id })
    PushNotificationJob.perform_later(Account.managing(profile_ids).where.not(id: sender_account_id).ids,
      sender_profile&.name.to_s, body.truncate(120), { type: "message", conversation_id: conversation_id })
  end

  def set_sent_at
    self.sent_at ||= Time.current
  end

  def sender_has_access_to_conversation
    return if conversation.blank? || sender_account.blank?

    participant_profile_ids = [ conversation.profile_a_id, conversation.profile_b_id ]
    sender_profile_ids = sender_account.profiles.pluck(:id)

    unless (sender_profile_ids & participant_profile_ids).any?
      errors.add(:base, "sender does not have access to a profile in this conversation")
    end
  end
end
