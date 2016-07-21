class GameMaster < ActiveRecord::Base
  belongs_to :table
  belongs_to :user_event
  validates :table_id, :presence => true, :uniqueness => {:scope => :user_event_id}
  validates :user_event_id, :presence => true, :uniqueness => {:scope => :table_id}
end
