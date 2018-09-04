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
    unless table.registration_tables.include? (self)
      errors.add :registration_tables, "Max Players Exceeded" if table.registration_tables.count >= table.max_players
    end
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


  def self.to_csv
    attributes = %w{ticket_number event session start_time scenario player pfs_number event_ticket_id}

    CSV.generate(headers: true) do |csv|
      csv << attributes
      all.each do |ticket|
        csv << [ticket.id, ticket.event, ticket.session, ticket.session_start_time, ticket.scenario, ticket.player, ticket.pfs_number, ticket.registration_number]
      end
    end
  end

  def event
    user_event.name
  end

  def session
    table.session.name
  end

  def session_start_time
    table.session.start.to_s(:long)
  end

  def scenario
    table.scenario.long_name
  end

  def player
     user_event.user.formal_name
  end

  def pfs_number
    user_event.user.pfs_number
  end

  def registration_number
    user_event.id
  end
end


