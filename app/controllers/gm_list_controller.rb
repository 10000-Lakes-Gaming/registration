class GmListController < ApplicationController
  before_action :get_event

  def index
    # need to collect in the stuff. Make it easier to consume
    @game_masters = []
    @event.user_events.each do |user_event|
      @game_masters = (@game_masters << user_event.game_masters).flatten!
    end

    @game_masters = @game_masters.sort { |a, b| a <=> b }

  end
end
