class PowerUser < ApplicationRecord
  belongs_to :poll_category
  belongs_to :user
  validates :user_id, uniqueness: { scope: :poll_category_id }
end
