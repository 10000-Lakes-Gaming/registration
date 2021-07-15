# frozen_string_literal: true

class EventReceiptController < ApplicationController
  before_action :get_event
  before_action :get_user_event, only: [:show]

  def index
    render layout: 'table-assignment'
  end

  def get_user_event
    @user_event = UserEvent.find(params[:id])
  end
end
