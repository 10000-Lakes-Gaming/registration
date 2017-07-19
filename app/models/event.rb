class Event < ActiveRecord::Base
  has_many :sessions, dependent: :destroy
  has_many :user_events, dependent: :destroy

  def <=> (event)
    self.name <=> event.name
  end

  def closed?
    closed = false
    unless self.rsvp_close.nil?
      now    = DateTime.now
      closed = self.rsvp_close <= now
    end
    closed
  end

  def premium_tables
    premium_tables = []
    sessions.each do |session|
      premium_tables.concat(session.tables.select {|table| table.premium})
    end
    premium_tables
  end

  def prereg_closed?
    closed = false
    unless self.prereg_ends.nil?
      now    = DateTime.now
      closed = self.prereg_ends <= now
    end
    closed
  end

  def early_bird?
    self.prereg_ends != self.rsvp_close
  end

  def price
    prereg_closed? ? onsite_price : prereg_price
  end

end
