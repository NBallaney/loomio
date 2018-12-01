class CreatePowerGroups < ActiveRecord::Migration[5.1]
  def change
    create_table :power_groups do |t|
      t.integer :vote_power
      t.integer :parent_id
      t.references :group, foreign_key: true

      t.timestamps
    end
    add_index :power_groups, :parent_id
  end
end
