# frozen_string_literal: true

class Event < ActiveRecord::Base
  has_many :sessions, dependent: :destroy
  has_many :user_events, dependent: :destroy, after_add: :set_donation
  has_many :event_hosts, dependent: :destroy
  has_many :tables, through: :sessions
  has_many :scenarios, through: :tables
  has_many :game_masters, through: :tables
  has_many :registration_tables, through: :tables
  has_many :additional_payments, through: :user_events

  validate :event_type_validator
  validate :optional_fee_validator
  validate :chat_server_validator

  def set_donation(user_event)
    return unless optional_fee?
    return unless user_event.donation.blank?

    user_event.donation = price
  end

  # TODO: do this through association?
  def player_tables
    tables.reject(&:headquarters?)
  end

  def unique_scenarios
    scenarios.uniq.reject(&:headquarters?)
  end

  def timeslot
    "#{start.strftime(Session::DATETIME_FORMAT)} to #{self.end.strftime(Session::DATETIME_FORMAT)}"
  end

  def formatted_start
    start.strftime(Session::DATETIME_FORMAT)
  end

  def formatted_end
    self.end.strftime(Session::DATETIME_FORMAT)
  end

  def formatted_rsvp_close
    rsvp_close.strftime(Session::DATETIME_FORMAT)
  end

  def formatted_prereg_ends
    prereg_ends.strftime(Session::DATETIME_FORMAT)
  end

  def formatted_online_sales_end
    online_sales_end.strftime(Session::DATETIME_FORMAT)
  end

  def offers_tee_shirt?
    tee_shirt_price&.nonzero?
  end

  def formatted_tee_shirt_end
    tee_shirt_end.strftime(Session::DATE_FORMAT)
  end

  def chat_server_validator
    errors[:chat_server].push 'must have both a name and a valid URL' unless valid_chat_server
  end

  def valid_chat_server
    # using Rails blank? instead of nil to catch all whitespace or empty string
    return true if chat_server.blank? && chat_server_url.blank?

    return true if chat_server.present? && chat_server_url.present?

    false
  end

  def chat_server?
    chat_server.present? && chat_server_url.present?
  end

  def event_type_validator
    errors[:online].push 'must have one of online or in person selected' unless event_type_selected?
  end

  OPTIONAL_FEE_MESSAGE = 'must not be checked unless this event is a charity event'

  def optional_fee_validator
    errors[:optional_fee].push OPTIONAL_FEE_MESSAGE unless charity_optional_fee_ok?
  end

  def charity_optional_fee_ok?
    return true if charity

    !optional_fee
  end

  def event_type_selected?
    in_person || online
  end

  def hybrid?
    in_person && online
  end

  def <=>(other)
    name <=> other.name
  end

  def closed?
    closed = false
    unless rsvp_close.nil?
      now = DateTime.now
      closed = rsvp_close <= now
    end
    closed
  end

  def date_range
    "#{start.localtime.to_formatted_s(:long)} to #{self.end.localtime.to_formatted_s(:long)}"
  end

  def premium_tables
    premium_tables = []
    sessions.each do |session|
      premium_tables.concat(session.tables.select(&:premium))
    end
    premium_tables
  end

  def prereg_closed?
    closed = false
    unless prereg_ends.nil?
      now = DateTime.now
      closed = prereg_ends <= now
    end
    closed
  end

  def online_sales_closed?
    closed = false
    unless online_sales_end.nil?
      now = DateTime.now
      closed = online_sales_end <= now
    end
    closed
  end

  def early_bird?
    prereg_ends != rsvp_close
  end

  def price
    prereg_closed? ? onsite_price : prereg_price
  end

  def early_bird_discount?
    prereg_price < onsite_price
  end

  # this will be a hash of tables
  def muster_sheet
    muster = {}
    sessions.sort { |a, b| a.start <=> b.start }.each do |session|
      next if session.tables.size == session.headquarters_tables.size
      tables = {}
      session.tables.each do |table|
        if table.game_masters.size > 1
          table.game_masters.each do |gm|
            table_m = {}
            table_m['table_number'] = gm.table_number
            table_m['scenario'] = table.scenario.long_name
            table_m['tier'] = table.scenario.tier
            table_m['gm'] = gm.user_event&.user.name
            tables[gm.table_number] = table_m
          end
        else
          table_m = {}
          table_m['table_number'] = table.location
          table_m['scenario'] = table.scenario.long_name
          table_m['tier'] = table.scenario.tier
          table_m['gm'] = table.game_masters.first&.user_event&.user&.name
          tables[table.location] = table_m
        end
      end
      muster[session] = tables
    end
    muster
  end
end
