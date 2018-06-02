class CreatePollCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :poll_categories do |t|
      t.string :name
      t.integer :pass_percentage
      t.integer :stop_percentage
      t.integer :active_days
      t.integer :resubmission_active_days
      t.integer :pass_percentage_drop

      t.timestamps
    end
  end
end
