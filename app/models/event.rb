class Event < ActiveRecord::Base
  has_many :sessions, dependent: :destroy
  has_many :user_events, dependent: :destroy
  has_many :event_hosts, dependent: :destroy
  has_many :tables, through: :sessions
  has_many :game_masters, through: :tables
  has_many :registration_tables, through: :tables

  validate :event_type_validator
  validate :has_chat_server_validator

  def has_chat_server_validator
    errors[:chat_server].push 'must have both a name and a valid URL' unless self.valid_chat_server
  end

  def valid_chat_server
    # using Rails blank? instead of nil to catch all whitespace or empty string
    if self.chat_server.blank?
      return true if self.chat_server_url.blank?
    end

    if self.chat_server.present?
      return true if self.chat_server_url.present?
    end

    false
  end

  def event_type_validator
    errors[:online].push 'must have one of online or in person selected' unless self.event_type_selected
  end

  def event_type_selected
    self.in_person || self.online
  end

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

  def date_range
    "#{start.localtime.to_formatted_s(:long)} to #{self.end.localtime.to_formatted_s(:long)}"
  end

  def premium_tables
    premium_tables = []
    sessions.each do |session|
      premium_tables.concat(session.tables.select { |table| table.premium })
    end
    premium_tables
  end

  def prereg_closed?
    closed = false
    unless self.prereg_ends.nil?
      now = DateTime.now
      closed = self.prereg_ends <= now
    end
    closed
  end

  def online_sales_closed?
    closed = false
    unless self.online_sales_end.nil?
      now = DateTime.now
      closed = self.online_sales_end <= now
    end
    closed
  end

  def early_bird?
    self.prereg_ends != self.rsvp_close
  end

  def price
    prereg_closed? ? onsite_price : prereg_price
  end

  def early_bird_discount?
    self.prereg_price < self.onsite_price
  end
end
