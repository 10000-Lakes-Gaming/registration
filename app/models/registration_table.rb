class RegistrationTable < ActiveRecord::Base
  belongs_to :user_event
  belongs_to :table
  delegate :name, to: :table
  delegate :start, to: :table
  validates :table_id, :presence => true, :uniqueness => {:scope => :user_event_id}
  validates :user_event_id, :presence => true, :uniqueness => {:scope => :table_id}
end
