class Table < ActiveRecord::Base
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
  validate :validate_max_players
  validates :scenario_id, :session_id, :gms_needed, :presence => true
  # Online validations
  validate :validate_online
  validates_presence_of :location, if: :online, :message => 'required when table is online'
  validates_numericality_of :gms_needed, greater_than: 0
  validates_numericality_of :gms_needed, if: :online,  equal_to: 1
  validates_numericality_of :max_players, if: :online,  less_than_or_equal_to: 6

  def validate_online
    if self.online?
      errors[:online] << 'cannot be set if event is not online' unless event.online?
    else
      errors[:online] << 'must be seet of event is not in_person' unless event.in_person?
    end
  end

  def validate_max_players
    if session.event.tables_reg_offsite
      self.max_players = 0 if self.max_players.blank?
    else
      if max_players.nil?
        errors[:max_players] << 'cannot be blank'
      elsif max_players <= 0
        errors[:max_players] << 'must be greater than 0'
      end
    end
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

  def <=> (tab)
    # Remove "Table"  and sort by number, if possible.
    myloc = self.location.to_s.downcase[/\d+/]
    tabloc = tab.location.to_s.downcase[/\d+/]
    sort = myloc.to_i <=> tabloc.to_i

    if sort == 0
      sort = self.location.to_s <=> tab.location.to_s
    end
    if sort == 0
      sort = self.raffle.to_s <=> tab.raffle.to_s

    end
    if sort == 0
      sort = self.core.to_s <=> tab.core.to_s
    end

    if sort == 0
      sort = self.scenario <=> tab.scenario
    end
    sort
  end

  def long_name
    "#{scenario.long_name} [#{session.name}]"
  end

  def check_player_count
    errors.add :registration_tables
  end

  def full?
    self.remaining_seats <= 0
  end

  def remaining_seats
    self.max_players - current_registrations
  end

  def current_registrations
    self.registration_tables.length
  end

  def need_gms?
    gms_short > 0
  end

  def gms_short
    self.gms_needed - current_gms
  end

  def current_gms
    self.game_masters.length
  end

  def closed?
    disabled? || session.event.online_sales_closed?
  end

  def price
    session.event.prereg_closed? ? onsite_price : prereg_price
  end

  def early_bird_discount?
    self.price < self.onsite_price
  end

  def gm_table_assignments
    tabs = []
    game_masters.collect { |gm|
      unless gm.table_number.blank?
        tabs << gm.table_number.strip
      end
    }
    # sort by the number...
    tabs.sort_by { |x| x[/\d+/].to_i }.join(", ")
  end

  def seats_available?
    max_players > registration_tables.length
  end

  def overlaps?(other_table)
    return false if other_table.nil?

    # Wow... never even realized that I did that...
    (self.start.utc < other_table.end.utc) && (self.end.utc > other_table.start.utc)
  end

  def tickets_overlap?(registration)
    return false if registration.nil?

    overlap = registration.registration_tables.any? { |ticket| overlaps?(ticket.table) }
    overlap || registration.game_masters.any? { |gm| overlaps?(gm.table) }
  end

  def can_sign_up?(registration)
    return false if registration.nil?

    ok = (!session.event.gm_select_only? || session.event.gm_signup? && registration.gamemaster?)
    ok &&= !self.raffle?
    ok &&= !session.event.closed?
    ok &&= !session.event.online_sales_closed?
    ok &&= !session.event.tables_reg_offsite?
    ok &&= game_masters.present?
    ok &&= registration.payment_ok?
    ok && !tickets_overlap?(registration)
  end

  def can_gm_select?(registration)
    return false if registration.nil?

    ok = !session.event.closed?
    ok &&= !session.event.online_sales_closed?
    ok &&= gm_self_select?
    ok &&= need_gms?
    ok &&= registration.payment_ok?
    ok && !tickets_overlap?(registration)
  end
end
