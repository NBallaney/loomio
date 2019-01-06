class API::GroupsController < API::RestfulController
  include UsesFullSerializer
  after_action :track_visit, only: :show

  def token
    self.resource = load_and_authorize(:formal_group, :invite_people)
    respond_with_resource scope: {include_token: true}
  end

  def show
    self.resource = load_and_authorize(:formal_group)
    respond_with_resource
  end

  def invitable_groups
    self.resource = load_and_authorize(:formal_group)
    ids = resource.child_groups.pluck(:id) << resource.id
    groups = FormalGroup.where("id not in (?)",ids)
    respond_to do |f|
      f.json {render json: {:groups => groups, :status => 200}.as_json}
    end
  end

  def group_members
    self.resource = load_and_authorize(:formal_group)
    members = resource.memberships.active.map(&:user)
    groups = resource.child_groups
    parent_groups = GroupMembership.where(child_group_id: resource.id).map(&:parent_group)
    respond_to do |f|
      f.json {render json: {:groups => groups, members: members, parent_groups: parent_groups, :status => 200}.as_json}
    end
  end

  def index
    instantiate_collection { |collection| collection.search_for(params[:q]).order(recent_activity_count: :desc) }
    respond_with_collection
  end

  def count_explore_results
    render json: { count: Queries::ExploreGroups.new.search_for(params[:q]).count }
  end

  def archive
    service.archive(group: load_resource, actor: current_user)
    respond_with_resource
  end

  def subgroups
    self.collection = load_and_authorize(:group).subgroups.select { |g| current_user.can? :show, g }
    respond_with_collection
  end

  def upload_photo
    ensure_photo_params
    service.update group: load_resource, actor: current_user, params: { params[:kind] => params[:file] }
    respond_with_resource
  end

  private
  def track_visit
    VisitService.record(group: resource, visit: current_visit, user: current_user)
  end

  def ensure_photo_params
    params.require(:file)
    raise ActionController::UnpermittedParameters.new([:kind]) unless ['logo', 'cover_photo'].include? params.require(:kind)
  end

  def accessible_records
    Queries::ExploreGroups.new
  end

  def resource_class
    FormalGroup
  end

  # serialize out the parent with the group
  def resources_to_serialize
    Array(collection || [resource, resource&.parent].compact)
  end

  def resource_serializer
    if ["show"].include? params[:action]
      Groups::ShowSerializer
    else
      GroupSerializer
    end
  end
end
