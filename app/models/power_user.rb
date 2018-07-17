class PowerUser < ApplicationRecord
  belongs_to :poll_category
  belongs_to :user
end
