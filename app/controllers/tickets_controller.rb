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
        @tickets.concat @empty_tickets
        cvs_data = @tickets.to_csv
        send_data(cvs_data, filename: "#{@event.name}_tickets.csv")
      end
    end
  end

  private

  def get_empty_tickets
    @empty_tickets = []
    @event.sessions.each do |session|
      session.tables.each do |table|
        next if table.online? || (%w[HQ Overseer].include? table.location)

        # use number of remaining seats.
        remaining_seats = table.remaining_seats
        next unless remaining_seats.positive?

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
    end
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
