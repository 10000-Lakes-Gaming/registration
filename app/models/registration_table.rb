class RegistrationTable < ActiveRecord::Base
  belongs_to :user_event
  belongs_to :table
  delegate :name, to: :table
  delegate :start, to: :table
  delegate :price, to: :table
  validates :table_id, :presence => true, :uniqueness => { :scope => :user_event_id }
  validates :user_event_id, :presence => true, :uniqueness => { :scope => :table_id }
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

  def self.to_csv (empty_tickets = nil)
    attributes = %w{ticket_number total_seats event session start_time scenario name formal_name pfs_number event_ticket_id, price}

    CSV.generate(headers: true) do |csv|
      csv << attributes
      all.each do |ticket|
        csv << [ticket.seat, ticket.table.max_players, ticket.event, ticket.session, ticket.session_start_time, ticket.scenario, ticket.player, ticket.formal_name, ticket.pfs_number, ticket.seat, ticket.ticket_price]
      end
      unless empty_tickets.blank?
        empty_tickets.each do |ticket|
          csv << [ticket.seat, ticket.table.max_players, ticket.event, ticket.session, ticket.session_start_time, ticket.scenario, ticket.player, ticket.formal_name, ticket.pfs_number, ticket.registration_number, ticket.ticket_price]
        end
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

  def formal_name
    user_event.user.formal_name
  end

  def player
    user_event.user.name
  end

  def pfs_number
    if user_event.user.pfs_number.nil?
      "DCI##{user_event.user.dci_number}"
    else
      user_event.user.pfs_number
    end
  end

  def registration_number
    user_event.id
  end

  def ticket_price
    if price == 0
      nil
    else
      ActionController::Base.helpers.number_to_currency price
    end
  end
end


