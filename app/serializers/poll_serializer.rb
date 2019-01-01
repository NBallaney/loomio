class PollSerializer < ActiveModel::Serializer
  embed :ids, include: true
  attributes :id, :discussion_id, :group_id, :key, :poll_type, :title, :details,
             :stance_data, :stance_counts, :matrix_counts, :anyone_can_participate, :voter_can_add_options, :deanonymize_after_close,
             :closed_at, :closing_at, :stances_count, :undecided_count, :versions_count,
             :created_at, :multiple_choice, :custom_fields, :poll_option_names,
             :notify_on_participate, :subscribed, :example, :anonymous, :pass_percentage, :stop_percentage,
             :resubmission_active_days, :pass_percentage_drop, :resubmission_count, :poll_category_id,
             :poll_category_name, :status, :parent_id, :can_respond_maybe, :parents_names,
             :alliance_parent_id, :additional_data


  has_one :author, serializer: UserSerializer, root: :users
  has_one :current_outcome, serializer: Full::OutcomeSerializer, root: :outcomes
  has_one :my_stance, serializer: StanceSerializer, root: :stances
  has_one :guest_group, serializer: Simple::GroupSerializer, root: :groups
  has_one :child_poll, serializer: PollSerializer, root: :child_poll
  has_many :parents, serializer: PollSerializer
  has_many :poll_options, serializer: PollOptionSerializer, root: :poll_options

  def subscribed
    object.poll_unsubscriptions.find_by(user: scope[:current_user]).blank?
  end

  def parents
    parents = get_parents object
    parents
  end

  def get_parents object
    parents = []
    parents << (parent1 = object.parent_poll) if object.parent_poll
    parents << (parent2 = parent1.parent_poll) if( parent1 && parent1.parent_poll)
    parents << (parent3 = parent2.parent_poll) if( parent2 && parent2.parent_poll)
    parents
  end

  def poll_category_name
    object.poll_category.try(:name)
  end

  def parents_names
    parents = get_parents object
    parents.map(&:title)
  end

  def my_stance
    @my_stances_cache ||= scope[:my_stances_cache].get_for(object) if scope[:my_stances_cache]
  end

  def include_subscribed?
    (scope || {})[:current_user].present?
  end

  def include_matrix_counts?
    object.chart_type == 'matrix'
  end
end
