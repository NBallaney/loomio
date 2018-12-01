class CreateGroupMemberships < ActiveRecord::Migration[5.1]
  def change
    create_table :group_memberships do |t|
      t.integer :parent_group_id
      t.integer :child_group_id

      t.timestamps
    end
    add_index :group_memberships, :parent_group_id
    add_index :group_memberships, :child_group_id
  end
end
