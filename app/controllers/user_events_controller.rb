# frozen_string_literal: true

class UserEventsController < ApplicationController
  include ApplicationHelper
  before_action :get_user_event, only: %i[show edit update destroy]
  before_action :get_event, :get_users, :get_all_events

  def get_user
    @user = current_user
  end

  def get_user_event
    @user_event = UserEvent.find(params[:id])
  end

  def get_users
    @users = User.all.order(:name)
  end

  def get_event
    @event = Event.find(params[:event_id])
  end

  def get_all_events
    @events = Event.all.order(:start).order(:name)
  end

  # GET /user_events
  # GET /user_events.json
  def index
    return unless restrict_to_hosts

    @user_events = @event.user_events
    # remove all user_events that don't have an event or user
    @user_events.each do |user_event|
      if user_event.user.nil? || user_event.event.nil?
        @user_events - [user_event]
        user_event.destroy
      end

      # how many have paid?
      @paid = 0
      @user_events.each do |rsvp|
        @paid += 1 if rsvp.paid?
      end
    end
    respond_to do |format|
      format.html do
        @user_events = @user_events.sort { |a, b| a <=> b }
        render :index
      end
      format.json do
        @user_events = @user_events.sort { |a, b| a <=> b }
        render :index
      end
      format.csv do
        send_data @user_events.to_csv, filename: "#{@event.name}_badges.csv"
      end
    end
    # sort the user events by email?
  end

  # GET /user_events/1
  # GET /user_events/1.json
  def show; end

  # GET /user_events/new
  def new
    @user_event = if current_user.admin?
                    UserEvent.new({ event: @event })
                  else
                    UserEvent.new({ user: current_user, event: @event })
                  end
    @event.set_donation(@user_event)
  end

  # GET /user_events/1/edit
  def edit; end

  # POST /user_events
  # POST /user_events.json
  def create
    # this one is trickier, due to users needing to be able to do it.
    # here, we want to use the current user -- but we might have a way to have an admin register someone?
    # Note: we also don't want to create a user event if one already exists
    @user_event = @event.user_events.create(user_event_params)
    @user_event.user = current_user unless current_user.admin?

    respond_to do |format|
      if @user_event.save
        # on the notice add the event name
        format.html { redirect_to [@event, @user_event], notice: 'User was successfully registered.' }
        format.json { render :show, status: :created, location: [@event, @user_event] }
      else
        format.html { render :new }
        format.json { render json: @user_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /user_events/1
  # PATCH/PUT /user_events/1.json
  def update
    respond_to do |format|
      if @user_event.update(user_event_params)
        format.html { redirect_to [@event, @user_event], notice: 'User event was successfully updated.' }
        format.json { render :show, status: :ok, location: [@event, @user_event] }
      else
        format.html { render :edit }
        format.json { render json: @user_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_events/1
  # DELETE /user_events/1.json
  def destroy
    # TODO: - force to current user if not admin.
    # TODO - if not admin, redirect to home.
    @user_event.destroy
    respond_to do |format|
      format.html { redirect_to events_path, notice: 'User event was successfully unregistered.' }
      format.json { head :no_content }
    end
  end

  # New route/method - search by date
  def search; end

  def show_since
    start_date   = Time.zone.local(*params[:range_start].sort.map(&:last).map(&:to_i))
    @user_events = @event.user_events.where(['updated_at >= ?', start_date])
    # remove all user_events that don't have an event or user
    @user_events.each do |user_event|
      if user_event.user.nil? || user_event.event.nil?
        @user_events - [user_event]
        user_event.destroy
      end
    end

    respond_to do |format|
      format.html do
        @user_events = @user_events.sort { |a, b| a <=> b }
        render :index
      end
      format.json do
        @user_events = @user_events.sort { |a, b| a <=> b }
        render :index
      end
      format.csv do
        send_data @user_events.to_csv, filename: "#{@event.name}_badges.csv"
      end
    end
  end

  # Never trust parameters from the scary internet, only allow the allowlist through.def user_event_params
  def user_event_params
    params.require(:user_event).permit(:user_id, :event_id, :vip, :paid, :payment_amount, :payment_id, :payment_date,
                                       :since, :donation)
  end
end
