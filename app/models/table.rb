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
    game_masters.first&.sign_in_url if game_masters.length == 1
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
    if scenario.long_name.blank?
      ''
    else
      "#{scenario.long_name} (#{scenario.tier})"
    end
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

    # if game_masters.present? && registration.payment_ok? && session.id == 173
    #   Rails.logger.info "--------------------------------------------------"
    #   Rails.logger.info "Registration user: #{registration.user.formal_name}"
    #   Rails.logger.info "Table: #{self.long_name}"
    #   Rails.logger.info "Can Select (#{table_type}? #{registration.can_select?(table_type)}"
    #   Rails.logger.info "Seats available? #{seats_available?}"
    #   Rails.logger.info "GM Select only? #{session.event.gm_select_only?}"
    #   Rails.logger.info "GM can sign up? #{gm_can_signup?(registration)}"
    #   Rails.logger.info "Raffle? #{raffle?}"
    #   Rails.logger.info "Event closed? #{session.event.closed?}"
    #   Rails.logger.info "Event closed? #{session.event.closed?}"
    #   Rails.logger.info "Event closed? #{session.event.closed?}"
    #   Rails.logger.info "Online sales closed? #{session.event.online_sales_closed?}"
    #   Rails.logger.info "Offsite registration?  #{session.event.tables_reg_offsite?}"
    #   Rails.logger.info "GM exist?  #{game_masters.present?}"
    #   Rails.logger.info "Payment ok? #{ registration.payment_ok?}"
    #   Rails.logger.info "Tickets overlap? #{tickets_overlap?(registration)}"
    #   Rails.logger.info "--------------------------------------------------"
    # end
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
    game_masters.any? { |gm| gm.user_event&.user_id == user.id }
  end

  def self.to_tte_csv(event, tables)
    tabletop_events_code = event.tabletop_event_type_code
    # Event Type,Event Type ID,Name,Description,More Info URL,Preferred Start Time,Alternate Start Time,Max Tickets,Spaces Needed,Hosts Also Play,Duration,Age Range,Game System,Sponsor,Special Request Notes (include email addresses if multiple GMs)
    # Roleplaying Game,2E904A2A-DD56-11EC-A6C0-A28553C64EAE
    # Notes:  duration is in minutes
    # Times are `Friday at 12:00` or `Saturday at 08:00` -- suggestion is to name sessions thusly
    # Spaces is number of tables
    # Ages for us will be 'all'
    attributes = ['Event Type', 'Event Type ID', 'Name', 'Description', 'More Info URL', 'Preferred Start Time',
                  'Alternate Start Time', 'Max Tickets', 'Spaces Needed', 'Hosts Also Play', 'Duration',
                  'Age Range', 'Game System', 'Sponsor', 'Special Request Notes (include email addresses if multiple GMs)']
    CSV.generate(headers: true) do |csv|
      csv << attributes
      tables.each do |table|
        scenario = table.scenario
        table_description = scenario.description
        table_description = "#{table_description}\n#{table.information}"

        # TODO: Add things for repeatable, pregens only, assuming information has no pregens
        csv << ['Roleplaying Game', tabletop_events_code,
                table.schedule_name, "#{table_description}",
                scenario.paizo_url, table.session.name, table.session.name,
                table.max_players, table.gms_needed, 0, table.session.session_time_minutes,
                'teen', table.converted_game_system, '10,000 Lakes Gaming and MN-POP', 'Part of Paizo Organized Play Room in Scandinavia Ballroom']
      end
    end
  end


  def converted_game_system
    case scenario.game_system
    when Scenario::PFS2
      'Pathfinder 2'
    when Scenario::PFS1
      'Pathfinder 1'
    when Scenario::SFS
      'Starfinder'
    else
      scenario.game_system
    end
  end

  private
  def table_type
    online? ? UserEvent::ATTENDANCE_ONLINE : UserEvent::ATTENDANCE_IN_PERSON
  end
end
