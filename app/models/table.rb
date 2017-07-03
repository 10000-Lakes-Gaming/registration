class Table < ActiveRecord::Base
  belongs_to :session
  belongs_to :scenario
  has_many :registration_tables
  has_many :game_masters
  delegate :name, to: :scenario
  delegate :start, to: :session
  delegate :end, to: :session
  validates :scenario_id, :session_id, :max_players, :gms_needed, :presence => true
  validates_numericality_of :gms_needed, :max_players, greater_than: 0

  def <=> (tab)
    sort = self.raffle.to_s <=> tab.raffle.to_s

    if sort == 0
      sort = self.core.to_s <=> tab.core.to_s
    end

    if sort == 0
      sort = self.scenario <=> tab.scenario
    end
    sort
  end

  def long_name
    "#{scenario.name} (#{session.name})"
  end

  def check_player_count
    errors.add :registration_tables
  end

  def remaining_seats
    self.max_players - current_registrations
  end

  def current_registrations
    self.registration_tables.length
  end

  def gms_short
    self.gms_needed - current_gms
  end

  def current_gms
    self.game_masters.length
  end

end
