class ProfilePrompt < ApplicationRecord
  belongs_to :profile

  validates :question, presence: true
  validates :answer, presence: true
end