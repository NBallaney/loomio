class DelegateUser < ApplicationRecord
  belongs_to :user
  belongs_to :poll_category
  belongs_to :delegate, class_name: "User"
end
