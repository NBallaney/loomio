class PollCategory < ApplicationRecord
  
  has_many :polls
  has_many :power_users, dependent: :destroy
  has_many :delegate_users

end