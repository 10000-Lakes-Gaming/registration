class GmListController < ApplicationController
  before_action :get_event, :get_unknown_user, :get_unknown_user_event

  def index
    # need to collect in the stuff. Make it easier to consume
    @game_masters = []

    @event.sessions.each do |session|
      session.tables.each do |table|
        pad_gms table
        @game_masters = (@game_masters << table.game_masters).flatten!
      end
    end

    respond_to do |format|
      format.html {
        @game_masters = @game_masters.sort { |a, b| a <=> b }
        render :index
      }
      format.json { render :index }
      format.csv {
        send_data GameMaster.to_csv(@game_masters), filename: "gm_list.csv"
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
    game_master = GameMaster.new
    game_master.table = table
    game_master.user_event = @user_event
    table.game_masters << game_master
  end

  def get_unknown_user_event
    @user_event = UserEvent.new
    @user_event.event = @event
    @user_event.user = @unknown
  end

  def get_unknown_user
    @unknown = User.new
    @unknown.name = 'TBD'
  end
end
