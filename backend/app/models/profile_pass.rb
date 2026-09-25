class ProfilePass < ApplicationRecord
  belongs_to :profile
  belongs_to :passed_profile, class_name: "Profile"
end
