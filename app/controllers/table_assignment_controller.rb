# frozen_string_literal: true

class TableAssignmentController < ApplicationController
  before_action :get_event

  def index
    # should have everything with the event.
    render layout: 'table-assignment'
  end
end
