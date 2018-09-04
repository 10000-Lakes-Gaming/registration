class TicketsController < ApplicationController
  before_action :get_event, :get_tickets, :get_unknown_user, :get_unknown_user_event

  def index
    respond_to do |format|
      format.html {
        @tickets = @tickets.sort {|a, b| a <=> b}
        render :index
      }
      format.json {
        @tickets = @tickets.sort {|a, b| a <=> b}
        render :index
      }
      format.csv {
        send_data @tickets.to_csv, filename: "#{@event.name}_tickets.csv"
      }
    end

  end


  private
  def pad_gms(table)
    (1..table.gms_short).each do
      add_unknown_gm table
    end
  end

  def add_unknown_gm(table)
    game_master            = GameMaster.new
    game_master.table      = table
    game_master.user_event = @user_event
    table.game_masters << game_master
  end

  def get_unknown_user_event
    @user_event       = UserEvent.new
    @user_event.event = @event
    @user_event.user  = @unknown
  end

  def get_unknown_user
    @unknown      = User.new
    @unknown.name = 'TBD'
  end

  def get_tickets
    @tickets = @event.registration_tables
  end


end
