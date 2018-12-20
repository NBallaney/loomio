ActiveAdmin.register PollCategory, as: 'PollCategory' do
  
  belongs_to :group

  controller do
    def permitted_params
      params.permit!
    end

    def find_resource
      PollCategory.find(params[:id])
    end

    def update
      update! do |format|
        format.html { 
          if resource.errors.any?
            flash[:error] = resource.errors.full_messages.join(", ")
            redirect_to edit_admin_group_poll_category_path(resource.group, resource) 
          else
            redirect_to admin_group_poll_category_path(resource.group, resource) 
          end
        }
      end
    end
  end

  form do |f|
    f.inputs 'Teams' do
      input :group_id, :as => :select, :collection => FormalGroup.all.map {|u| [u.name, u.id]}
      input :name
      input :pass_percentage
      input :stop_percentage
      input :active_days
      input :resubmission_active_days
      input :pass_percentage_drop
    end
    actions
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