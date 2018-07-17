class PollCategory < ApplicationRecord
  
  has_many :polls
  has_many :power_users, dependent: :destroy
  has_many :delegate_users
  accepts_nested_attributes_for :power_users, reject_if: proc { |attributes| attributes['vote_power'].blank? }


  def as_json(options={})
    super(:include => [:power_users])
  end

end