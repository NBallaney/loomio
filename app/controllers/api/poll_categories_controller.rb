class API::PollCategoriesController < API::RestfulController

  def index
    @categories = PollCategory.all
    respond_to do |f|
      f.json {render json: {:categories => @categories, :status => 200}.as_json}
    end
  end

  def show
    @categories = PollCategory.find(params[:id])
    respond_to do |f|
      f.json {render json: {:categories => @categories, :status => 200}.as_json}
    end
  end

  def update
    if current_user.is_admin
      @category = PollCategory.find(params[:id])
      @category.update_attributes(poll_params)
      respond_to do |f|
        f.json {render json: {:message => "Category successfully upated", :status => 200}.as_json}
      end
    else
      respond_to do |f|
        f.json {render json: {:message => "You are not authorized.", :status => 200}.as_json}
      end
    end
  end

  #def create
  #	@category = PollCategory.create(poll_params)
  #	respond_to do |f|
  #	  f.json {message: "Category successfully created", status: 200}
  #	end
  #end

  #def update
  #	@category = PollCategory.create(poll_params)
  #	respond_to do |f|
  #	  f.json {message: "Category successfully upated", status: 200}
  #	end
  #end


  #private

  def poll_params
  	params.require(:poll_category).permit(:id, :power_users_attributes => [:id, :user_id, :vote_power])
  end

end