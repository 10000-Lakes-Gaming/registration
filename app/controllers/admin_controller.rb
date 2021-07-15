# frozen_string_literal: true

class AdminController < ApplicationController
  before_action :restrict_to_admin

  def index; end
end
