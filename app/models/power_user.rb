class PowerUser < ApplicationRecord
  # Power suers are now group sepcific
  # belongs_to :poll_category
  belongs_to :group
  belongs_to :user
  validates :user_id, uniqueness: { scope: :group_id }
end
