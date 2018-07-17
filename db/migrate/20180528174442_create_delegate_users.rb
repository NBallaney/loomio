class CreateDelegateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :delegate_users do |t|
      t.references :user, foreign_key: true
      t.references :poll_category, foreign_key: true
      t.references :delegate, index: true

      t.timestamps
    end
  end
end
