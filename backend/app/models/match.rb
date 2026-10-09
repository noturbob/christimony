class Match < ApplicationRecord
  belongs_to :profile_a, class_name: "Profile"
  belongs_to :profile_b, class_name: "Profile"
  has_one :conversation, dependent: :destroy
  has_many :introductions, foreign_key: :parent_match_id, dependent: :delete_all

  validates :match_type, presence: true, inclusion: { in: %w[direct parent] }
  validates :matched_at, presence: true

  after_create_commit :notify

  private

  def notify
    profile_ids = [ profile_a_id, profile_b_id ]
    AccountChannel.notify(profile_ids, type: "match", match_id: id)
    PushNotificationJob.perform_later(Account.managing(profile_ids).ids, "It's a match", nil, { type: "match", match_id: id })
  end
end
