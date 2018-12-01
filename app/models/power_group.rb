class PowerGroup < ApplicationRecord
  belongs_to :group
  belongs_to :parent_group, foreign_key: "parent_id", class_name: "FormalGroup"
  validates :group_id, uniqueness: { scope: :parent_id }
end
