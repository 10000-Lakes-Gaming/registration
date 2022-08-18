# frozen_string_literal: true

class Table < ActiveRecord::Base # rubocop:disable  Metrics/ClassLength
  require 'csv'

  belongs_to :session
  belongs_to :scenario
  has_many :registration_tables
  has_many :game_masters
  delegate :name, to: :scenario
  delegate :start, to: :session
  delegate :end, to: :session
  delegate :prereg_ends, to: :session
  delegate :prereg_closed?, to: :session
  delegate :event, to: :session
  delegate :headquarters?, to: :scenario
  validate :validate_max_players
  validates :scenario_id, :session_id, :gms_needed, presence: true
  # Online validations
  validate :validate_online
  validates_presence_of :location, if: :online, message: 'required when table is online'
  validates_numericality_of :gms_needed, greater_than: 0
  validates_numericality_of :gms_needed, if: :online, equal_to: 1

  def validate_online
    if online?
      errors[:online] << 'cannot be set if event is not online' unless event.online?
    else
      errors[:online] << 'must be seet of event is not in_person' unless event.in_person?
    end
  end

  def validate_max_players
    self.max_players = 0 if max_players.blank?

    return if scenario&.headquarters?

    errors[:max_players] << 'must be greater than 0' if max_players <= 0 && !session.event.tables_reg_offsite
    errors[:max_players] << 'must be less than or equal to 6' if online? && max_players > 6
  end

  def self.import(session, file)
    tables = []
    CSV.foreach(file.path, headers: true) do |row|
      fields = row.to_h
      tables << Table.new({ session:,
                            scenario: Scenario.find(fields['scenario'].to_i),
                            online: ActiveModel::Type::Boolean.new.cast(fields['online']),
                            location: fields['location'],
                            gms_needed: fields['gms_needed'].to_i,
                            max_players: fields['max_players'].to_i })
    end
    tables.each(&:save!)
  end

  def vtt_type
    game_masters.first&.vtt_type
  end

  def vtt_name
    game_masters.first&.vtt_name
  end

  def vtt_url
    game_masters.first&.vtt_url
  end

  def sign_in_url
    game_masters.first&.sign_in_url
  end

  def <=>(other)
    # Remove "Table"  and sort by number, if possible.
    myloc = location.to_s.downcase[/\d+/]
    tabloc = other.location.to_s.downcase[/\d+/]
    sort = myloc.to_i <=> tabloc.to_i

    sort = location.to_s <=> other.location.to_s if sort.zero?
    sort = raffle.to_s <=> other.raffle.to_s if sort.zero?
    sort = core.to_s <=> other.core.to_s if sort.zero?

    sort = scenario <=> other.scenario if sort.zero?
    sort
  end

  def schedule_name
    "#{scenario.long_name} (#{scenario.tier})"
  end

  def long_name
    if online?
      if premium?
        "#{scenario.long_name} (#{scenario.tier}) [#{session.name}] #{location} Online Premium"
      else
        "#{scenario.long_name} (#{scenario.tier}) [#{session.name}] #{location} Online"
      end
    elsif premium?
      "#{scenario.long_name} (#{scenario.tier}) [#{session.name}] #{location} Premium"
    else
      "#{scenario.long_name} (#{scenario.tier}) [#{session.name}] #{location}"
    end
  end

  def check_player_count
    errors.add :registration_tables
  end

  def full?
    remaining_seats <= 0
  end

  def remaining_seats
    total_seats = max_players
    available_seats = max_players

    if need_gms?
      seats_per_gm = (total_seats / gms_needed).to_i
      available_seats = seats_per_gm * current_gms
    end
    available_seats - current_registrations
  end

  def current_registrations
    registration_tables.length
  end

  def need_gms?
    gms_short.positive?
  end

  def gms_short
    gms_needed - current_gms
  end

  def current_gms
    game_masters.length
  end

  def closed?
    disabled? || session.event.online_sales_closed?
  end

  def price
    session.event.prereg_closed? ? onsite_price : prereg_price
  end

  def early_bird_discount?
    price < onsite_price
  end

  def gm_table_assignments
    tabs = []
    game_masters.collect do |gm|
      tabs << gm.table_number.strip unless gm.table_number.blank?
    end
    # sort by the number...
    tabs.sort_by { |x| x[/\d+/].to_i }.join(', ')
  end

  def seats_available?
    max_players > registration_tables.length
  end

  def overlaps?(other_table)
    return false if other_table.nil?

    # Wow... never even realized that I did that...
    (start.utc < other_table.end.utc) && (self.end.utc > other_table.start.utc)
  end

  def tickets_overlap?(registration)
    return false if registration.nil?

    overlap = registration.registration_tables.any? { |ticket| overlaps?(ticket.table) }
    overlap || registration.game_masters.any? { |gm| overlaps?(gm.table) }
  end

  def can_sign_up?(registration)
    return false if registration.nil?

    ok = registration.can_select?(table_type)
    ok &&= seats_available?
    ok &&= !session.event.gm_select_only? || gm_can_signup?(registration)
    ok &&= !raffle?
    ok &&= !session.event.closed?
    ok &&= !session.event.online_sales_closed?
    ok &&= !session.event.tables_reg_offsite?
    ok &&= game_masters.present?
    ok &&= registration.payment_ok?
    ok && !tickets_overlap?(registration)
  end

  def gm_can_signup?(registration)
    can_signup = session.event.gm_signup? && registration.can_select?(table_type)
    can_signup &&= registration.gamemaster?
    # must have at least as many GM as player
    can_signup && registration.game_masters.length > registration.registration_tables.length
  end

  def can_gm_select?(registration)
    return false if registration.nil?

    ok = !session.event.closed? && registration.can_select?(table_type)
    ok &&= !session.event.online_sales_closed?
    ok &&= gm_self_select?
    ok &&= need_gms?
    ok &&= registration.payment_ok?
    ok && !tickets_overlap?(registration)
  end

  def table_gm?(user)
    game_masters.any? { |gm| gm&.user_event&.user_id == user.id }
  end

  private

  def table_type
    online? ? UserEvent::ATTENDANCE_ONLINE : UserEvent::ATTENDANCE_IN_PERSON
  end
end
