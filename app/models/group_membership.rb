class GroupMembership < ApplicationRecord
  belongs_to :parent_group, foreign_key: 'parent_group_id', class_name: "FormalGroup"
  belongs_to :child_group, foreign_key: 'child_group_id', class_name: "FormalGroup"
end
