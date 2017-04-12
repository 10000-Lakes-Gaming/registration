class UserEvent < ActiveRecord::Base
  belongs_to :user
  belongs_to :event
  has_many :registration_tables
  has_many :game_masters
  validates :event_id, :presence => true, :uniqueness => {:scope => :user_id}
  validates :user_id, :presence => true, :uniqueness => {:scope => :event_id}
  delegate :name, to: :event

  def <=> (other)
    self.user <=> other.user
  end

  def gamemaster?
    !game_masters.nil? and game_masters.length > 0
  end
end
