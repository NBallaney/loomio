class PollCategory < ApplicationRecord
  
  validates :active_days, numericality: { only_integer: true, greater_than: 0 }
  validates :resubmission_active_days, numericality: { only_integer: true, greater_than: 0 }
  
  has_many :polls
  # Power users would now be group specific
  #has_many :power_users, dependent: :destroy
  #accepts_nested_attributes_for :power_users, reject_if: proc { |attributes| attributes['vote_power'].blank? }
  has_many :delegate_users
  belongs_to :group

  scope :special, -> { where(special: true) }


  # def as_json(options={})
  #   super(:include => [:power_users])
  # end

end