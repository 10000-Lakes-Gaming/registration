class GmListController < ApplicationController
  before_action :get_event

  def index
    # need to collect in the stuff. Make it easier to consume
    @game_masters = []
    @event.user_events.each do |user_event|
      @game_masters = (@game_masters << user_event.game_masters).flatten!
    end
    @game_masters = @game_masters.sort { |a, b| a <=> b }

    # now remove duplicate scenarios
    previous_scenario = nil
    @game_masters.each do |gm|
      if gm.table.scenario == previous_scenario
        @game_masters - [gm]
      else
        previous_scenario = gm.table.scenario
      end
    end
  end
end
