class ChangeAdditionalDataType < ActiveRecord::Migration[5.1]
  def change
  	change_column :polls, :additional_data, 'jsonb USING CAST(additional_data AS jsonb)'
  end
end
