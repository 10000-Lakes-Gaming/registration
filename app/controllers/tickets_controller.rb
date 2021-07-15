class TicketsController < ApplicationController
  before_action :get_event, :get_unknown_user, :get_unknown_user_event, :get_real_tickets, :get_empty_tickets

  def index
    respond_to do |format|
      format.html {
        @tickets = @tickets.sort {|a, b| a <=> b}
        @tickets += @empty_tickets
        render :index
      }
      format.json {
        @tickets = @tickets.sort {|a, b| a <=> b}
        @tickets += @empty_tickets
        render :index
      }
      format.csv {
        send_data @tickets.to_csv(@empty_tickets), filename: "#{@event.name}_tickets.csv"
      }
    end
  end

  private

  def get_empty_tickets
    @empty_tickets = []
    @event.sessions.each do |session|
      session.tables.each do |table|
        unless ["HQ", "Overseer"].include? table.location
          # use number of remaining seats.
          remaining_seats = table.remaining_seats
          if remaining_seats > 0
            start          = table.current_registrations + 1
            needed_tickets = (start..table.max_players)
            needed_tickets.to_a.each do |seat|
              ticket            = RegistrationTable.new
              ticket.user_event = @user_event
              ticket.table      = table
              ticket.seat       = seat
              @empty_tickets << ticket
            end
          end
        end
      end
    end
    @empty_tickets
  end

  def get_unknown_user_event
    @user_event       = UserEvent.new
    @user_event.event = @event
    @user_event.user  = @unknown
  end

  def get_unknown_user
    @unknown      = User.new
    @unknown.name = ""
  end

  def get_real_tickets
    @tickets = @event.registration_tables
  end
end
