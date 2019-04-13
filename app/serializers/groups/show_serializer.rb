class Groups::ShowSerializer < GroupSerializer
  has_many :poll_categories, serializer: PollCategoriesSerializer

  attributes_for_formal :power_users, :power_groups


  def power_users
    PowerUser.where(group_id: object.id)
  end

  def power_groups
    PowerGroup.where(parent_id: object.id)
  end
end
