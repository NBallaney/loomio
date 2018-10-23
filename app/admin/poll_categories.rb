ActiveAdmin.register PollCategory, as: 'PollCategory' do
  
  belongs_to :group

  controller do
    def permitted_params
      params.permit!
    end

    def find_resource
      PollCategory.find(params[:id])
    end
  end

  index do
    column :name
    column "Special Category", :special
    #column :group_id
    column :pass_percentage
    column :stop_percentage
    column :active_days
    column "Resub. act. days", :resubmission_active_days
    column "Pass % drop", :pass_percentage_drop
    column :created_at
    actions
  end

  actions :index, :show, :new, :edit, :update, :create, :destroy

  filter :name
  filter :pass_percentage
  filter :stop_percentage
  filter :active_days
  filter :resubmission_active_days
  filter :pass_percentage_drop
  filter :created_at
  filter :special, label: "Special Category"
end