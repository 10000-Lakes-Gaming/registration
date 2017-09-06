class EventReceiptController < ApplicationController
  before_action :get_event
  before_action :get_user_event, only: [:show]

  def index
    render layout: "table-assignment"
  end

  def show
    render layout: "table-assignment"
  end
end
