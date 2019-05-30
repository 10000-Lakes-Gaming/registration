class TablesBySessionController < ApplicationController
  before_action :get_event

  def index
    # First, get all the tables possible. By name.
    # firstAttempt
    tableSessionMap
    render layout: "tables_by_session"
  end

  private

  def tableSessionMap
    # table_number -> session -> GM
    @tableSessionMap = {}
    @sessions        = @event.sessions.sort { |a, b| a.start <=> b.start }
    @sessions.sort.each do |session|
      session.tables.each do |table|
        unless ["HQ","Overseer"].include? table.location
          table.game_masters.each do |gm|
            table_number = gm.table_number.presence || "Unknown"
            table_number = table_number.strip
            table_hash   = @tableSessionMap[table_number]
            if table_hash.nil?
              table_hash = {}
            end
            table_hash[session]            = gm
            @tableSessionMap[table_number] = table_hash
          end
        end
      end
    end
    @tables = @tableSessionMap.keys.sort_by {|x| x[/\d+/].to_i}
    # Pass 2 -- go through again and fill out unused sessions
    unknown_user = User.new
    unknown_user.name = ""
    unknown_user_event = UserEvent.new
    unknown_user_event.event = @event
    unknown_user_event.user = unknown_user
    unknown_table = Table.new
    scenario = Scenario.new
    scenario.game_system = ""
    scenario.name = ""
    unknown_table.scenario = scenario
    @tables.each do |table_number|
      @sessions.each do |session|
        unless @tableSessionMap[table_number].include? session
          unknown_gm = GameMaster.new
          unknown_gm.table_number = table_number
          unknown_gm.table = unknown_table
          unknown_gm.user_event = unknown_user_event
          @tableSessionMap[table_number][session] = unknown_gm
         end
      end
    end
  end
end
