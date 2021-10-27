# frozen_string_literal: true

class TicketsController < ApplicationController
  before_action :get_event, :get_unknown_user, :get_unknown_user_event, :get_real_tickets, :get_empty_tickets

  def index
    respond_to do |format|
      format.html do
        @tickets = @tickets.sort { |a, b| a <=> b }
        @tickets += @empty_tickets
        render :index
      end
      format.json do
        @tickets = @tickets.sort { |a, b| a <=> b }
        @tickets += @empty_tickets
        render :index
      end
      format.csv do
        csv_data = RegistrationTable.to_csv @tickets, @empty_tickets
        send_data(csv_data, filename: "#{@event.name}_tickets.csv")
      end
    end
  end

  private

  def get_table_with_seats
    tables = []
    @event.sessions.each do |session|
      my_tables = session.tables
      my_tables = my_tables.reject { |table| table.online? }.select { |table| table.seats_available? }
      tables.concat my_tables
    end
    tables
  end

  def get_empty_tickets
    @empty_tickets = []
    get_table_with_seats
    get_table_with_seats.each do |table|
      Rails.logger.info "Checking table #{table.long_name}: is it full? #{table.full?} : #{table.remaining_seats}"
      next if (%w[HQ Overseer].include? table.location)
      next if table.full?

      start = table.current_registrations + 1
      needed_tickets = (start..table.max_players)
      needed_tickets.to_a.each do |seat|
        ticket = RegistrationTable.new
        ticket.user_event = @user_event
        ticket.table = table
        ticket.seat = seat
        @empty_tickets << ticket
      end
    end
    # end
    @empty_tickets
  end

  def get_unknown_user_event
    @user_event = UserEvent.new
    @user_event.event = @event
    @user_event.user = @unknown
  end

  def get_unknown_user
    @unknown = User.new
    @unknown.name = ''
  end

  def get_real_tickets
    # we want only in person tables.
    @tickets = @event.registration_tables.reject { |ticket| ticket.table.online? }
  end
end
