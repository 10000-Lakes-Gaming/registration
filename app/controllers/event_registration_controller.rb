class EventRegistrationController < ApplicationController
  before_action :get_event

  def index
    render layout: "table-assignment"
  end
end
