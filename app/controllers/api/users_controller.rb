class API::UsersController < API::RestfulController

  def index
    @users = User.all
    respond_to do |f|
      f.json {render json: {:users => @users, :status => 200}.as_json}
    end
  end
                                                                                          
  def assign_delegates
    @user = User.find(params[:id])
    @category = PollCategory.find(params[:poll_category_id])
    delegates_array, message = [], ""
    if params[:delegate_ids].size > 11
      message = "Delegates can't be more than 11"
    else
      params[:delegate_ids].each {|id| delegates_array << {:poll_category_id => @category.id, :delegate_id => id}}
      DelegateUser.where(id: @user.delegate_users.where(poll_category_id: @category.id).pluck(:id)).delete_all
      @user.delegate_users.create(delegates_array.uniq) if delegates_array.any?
      message = "Delegates assigned successfully"
    end
    respond_to do |f|
      f.json {render json: {:message => message, :status => 200}.as_json}
    end
  end

  def fetch_delegates
    @user = User.find(params[:id])
    @category = PollCategory.find(params[:poll_category_id]) if params[:poll_category_id]
    if @category
      @delegates = @user.delegate_users.where(poll_category_id: @category.id).map(&:delegate).flatten
    else
      @delegates = @user.delegate_users.map(&:delegate).flatten
    end
    respond_to do |f|
      f.json {render json: {:delegates => @delegates, :status => 200}.as_json}
    end
  end


end