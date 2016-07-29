class UserEvent < ActiveRecord::Base
  belongs_to :user
  belongs_to :event
  has_many :registration_tables
  has_many :game_masters
  validates :event_id, :presence => true, :uniqueness => {:scope => :user_id}
  validates :user_id, :presence => true, :uniqueness => {:scope => :event_id}
  delegate :name, to: :event


  def <=>(rsvp)
    sort = 0
    unless self == rsvp
      if self.user.nil?
        sort = -1;
      elsif rsvp.user.nil?
        sort = 1
      else
        sort = self.user <=> rsvp.user
      end
    end
    sort
  end
end
