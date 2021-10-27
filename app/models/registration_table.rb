# frozen_string_literal: true

class RegistrationTable < ActiveRecord::Base
  belongs_to :user_event
  belongs_to :table
  delegate :name, to: :table
  delegate :start, to: :table
  delegate :end, to: :table
  delegate :price, to: :table
  validates :table_id, presence: true, uniqueness: { scope: :user_event_id }
  validates :user_event_id, presence: true, uniqueness: { scope: :table_id }
  validate :check_player_count

  def check_player_count
    if !table.registration_tables.include?((self)) && (table.registration_tables.count >= table.max_players)
      errors.add :registration_tables, 'Max Players Exceeded'
    end
  end

  def payment_ok?
    paid? || table.price.nil? || table.price <= 0
  end

  def formatted_payment_date
    payment_date&.strftime(Session::DATETIME_FORMAT)
  end

  def <=>(other)
    # sort by user
    sorted = user_event <=> other.user_event
    if sorted.zero?
      # then scenario number
      sorted = table.scenario <=> other.table.scenario
    end
    sorted
  end

  def self.to_csv(tickets, empty_tickets = nil)
    attributes = %w[ticket_number total_seats event session start_time scenario name formal_name pfs_number
                    event_ticket_id price]

    CSV.generate(headers: true) do |csv|
      csv << attributes
      tickets.each do |ticket|
        csv << [ticket.seat, ticket.table.max_players, ticket.event, ticket.session, ticket.session_start_time,
                ticket.scenario, ticket.player, ticket.formal_name, ticket.pfs_number, ticket.seat, ticket.ticket_price]
      end
      unless empty_tickets.blank?
        empty_tickets.each do |ticket|
          csv << [ticket.seat, ticket.table.max_players, ticket.event, ticket.session, ticket.session_start_time,
                  ticket.scenario, ticket.player, ticket.formal_name, ticket.pfs_number, ticket.registration_number,
                  ticket.ticket_price]
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
    number = ''
    number = user_event.user.pfs_number.to_s unless user_event.user.pfs_number.blank?
    number = "DCI# #{user_event.user.dci_number}" if number.blank? && !user_event.user.dci_number.blank?
    number
  end

  def registration_number
    user_event.id
  end

  def ticket_price
    if price.zero?
      nil
    else
      ActionController::Base.helpers.number_to_currency price
    end
  end
end
