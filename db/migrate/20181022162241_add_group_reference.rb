class AddGroupReference < ActiveRecord::Migration[5.1]
  def change
    add_reference :poll_categories, :group, index: true
    add_reference :power_users, :group, index: true
    remove_reference :power_users, :poll_category, index: true, foreign_key: true
    Rake::Task["special_categories:create_categories_for_groups"].invoke
  end
end
