class Conversation < ApplicationRecord
  belongs_to :match
  has_many :messages

  delegate :profile_a, :profile_b, :profile_a_id, :profile_b_id, to: :match
end