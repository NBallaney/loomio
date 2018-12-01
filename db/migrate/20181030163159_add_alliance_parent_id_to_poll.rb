class AddAllianceParentIdToPoll < ActiveRecord::Migration[5.1]
  def change
    enable_extension "hstore"
    add_column :polls, :alliance_parent_id, :integer
    add_column :polls, :additional_data, :hstore
  end
end
