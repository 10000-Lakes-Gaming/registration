# frozen_string_literal: true

class GmsByScenarioController < ApplicationController
  before_action :get_event, :get_unknown_user, :get_unknown_user_event

  def index
    # have to put things in a hash, so that we can deal with it.
    @tables_by_scenario = {}
    @event.unique_scenarios.each { |scenario| @tables_by_scenario[scenario] = [] }
    @event.player_tables.each do |table|
      @tables_by_scenario[table.scenario] << table
    end

    respond_to do |format|
      format.html { render :index }
      format.json { render :index }
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
end
