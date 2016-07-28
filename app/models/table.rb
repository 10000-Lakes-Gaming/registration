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

  # TODO - This may not be needed forever
  after_initialize do
    if self.gms_needed.nil?
      self.gms_needed = 1
      self.save
    end
  end

  def <=> (tab)
    # first sort by the scenario
    sort = self.scenario <=> tab.scenario

    # then by core
    if sort == 0
      if tab.core == self.core
        sort = 0
      elsif tab.core
        sort = -1
      else
        sort = 1
      end
    end
    # then by raffle
    if sort == 0
      if tab.raffle == self.raffle
        sort = 0
      elsif tab.raffle
        sort = -1
      else
        sort = 1
      end
    end
    sort
  end
end
