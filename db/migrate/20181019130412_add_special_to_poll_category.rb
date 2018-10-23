class AddSpecialToPollCategory < ActiveRecord::Migration[5.1]
  def change
    add_column :poll_categories, :special, :boolean, default: false
  end
end
