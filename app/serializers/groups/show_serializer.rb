class Groups::ShowSerializer < GroupSerializer
  has_many :poll_categories, serializer: PollCategoriesSerializer
end
