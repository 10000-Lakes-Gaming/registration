class Event < ActiveRecord::Base
  has_many :sessions, dependent: :destroy
  has_many :user_events, dependent: :destroy


  def <=> (event)
    self.name <=> event.name
  end

  def closed?
    closed = false
    unless self.rsvp_close.nil?
      now = DateTime.now
      closed = self.rsvp_close <= now
    end
    closed
  end


end
