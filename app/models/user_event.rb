class UserEvent < ActiveRecord::Base
  belongs_to :user
  belongs_to :event
  has_many :registration_tables
  validates :event_id, :presence => true, :uniqueness => {:scope => :user_id}
  validates :user_id, :presence =>  true , :uniqueness => {:scope => :event_id}
  delegate :name, to: :event
end
