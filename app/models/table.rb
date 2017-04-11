class Table < ActiveRecord::Base
  belongs_to :session
  belongs_to :scenario
  has_many :registration_tables
  has_many :game_masters
  delegate :name, to: :scenario
  delegate :long_name, to: :scenario
  delegate :start, to: :session
  validates :scenario_id, :session_id, :max_players, :gms_needed, :presence => true
  validates_numericality_of :gms_needed, :max_players, greater_than: 0
  # validate :check_player_count

  def <=> (tab)
    sort = 0
    if tab.raffle == self.raffle
      sort = 0
    elsif tab.raffle
      sort = -1
    else
      sort = 1
    end

    if sort == 0
      if tab.core == self.core
        sort = 0
      elsif tab.core
        sort = -1
      else
        sort = 1
      end
    end

    if sort == 0
      sort = self.scenario <=> tab.scenario
    end
    sort
  end

  def check_player_count
    errors.add :registration_tables
  end

  def remaining_seats
    self.max_players - self.registration_tables.length
  end
  def gms_short
    self.gms_needed - self.game_masters.length
  end

end
