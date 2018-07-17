class AddAdditionalColumnsToPoll < ActiveRecord::Migration[5.1]
  def change
    add_column :polls, :pass_percentage, :integer
    add_column :polls, :stop_percentage, :integer
    add_column :polls,:resubmission_active_days,:integer
    add_column :polls, :pass_percentage_drop,:integer
    add_column :polls, :resubmission_count,:integer, :default => 0
    add_reference :polls, :poll_category, foreign_key: true
  end
end
