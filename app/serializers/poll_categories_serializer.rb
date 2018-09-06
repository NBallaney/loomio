class PollCategoriesSerializer < ActiveModel::Serializer
  embed :ids, include: true
  attributes :id, :name, :pass_percentage, :stop_percentage, 
             :active_days, :resubmission_active_days, :pass_percentage_drop, 
             :created_at, :updated_at
end


