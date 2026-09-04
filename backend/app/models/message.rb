class Message < ApplicationRecord
  belongs_to :conversation
  belongs_to :sender_account, class_name: "Account"

  validates :body, presence: true
  validates :sent_at, presence: true
  validate :sender_has_access_to_conversation

  before_validation :set_sent_at, on: :create

  private

  def set_sent_at
    self.sent_at ||= Time.current
  end

  def sender_has_access_to_conversation
    return if conversation.blank? || sender_account.blank?

    participant_profile_ids = [conversation.profile_a_id, conversation.profile_b_id]
    sender_profile_ids = sender_account.profiles.pluck(:id)

    unless (sender_profile_ids & participant_profile_ids).any?
      errors.add(:base, "sender does not have access to a profile in this conversation")
    end
  end
end