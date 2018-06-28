class RegistrationTable < ActiveRecord::Base
  belongs_to :user_event
  belongs_to :table
  delegate :name, to: :table
  delegate :start, to: :table
  delegate :price, to: :table
  validates :table_id, :presence => true, :uniqueness => {:scope => :user_event_id}
  validates :user_event_id, :presence => true, :uniqueness => {:scope => :table_id}
  validate :check_player_count

  def check_player_count
    errors.add :registration_tables, "Max Players Exceeded" if table.registration_tables.count >= table.max_players
  end

  def payment_ok?
    self.paid? || self.table.price.nil? || self.table.price <= 0
  end

  def <=> (other)
    # sort by user
    sorted = self.user_event <=> other.user_event
    if sorted == 0
      # then scenario number
      sorted = self.table.scenario <=> other.table.scenario
    end
    sorted
  end
end
