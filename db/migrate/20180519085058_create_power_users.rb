class CreatePowerUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :power_users do |t|
      t.integer :user_id
      t.integer :vote_power
      t.references :poll_category, foreign_key: true

      t.timestamps
    end
  end
end
