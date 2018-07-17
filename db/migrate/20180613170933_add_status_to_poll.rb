class AddStatusToPoll < ActiveRecord::Migration[5.1]
  def change
    add_column :polls, :status, :integer
    add_column :polls, :parent_id, :integer
    add_index :polls, :parent_id
  end
end
