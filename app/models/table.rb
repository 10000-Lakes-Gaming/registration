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
end
