class EventsController < ApplicationController
  include ApplicationHelper

  skip_before_action :authenticate_user!, only: %i[index show]
  before_action :set_event, only: [:show, :edit, :update, :destroy, :scenario_request_form]
  before_action :restrict_to_admin, except: [:show, :index, :scenario_request_form]
  before_action :restrict_to_hosts, only: [:scenario_request_form]
  before_action :get_events, :get_my_events

  # GET /events
  # GET /events.json
  def index
  end

  def get_events
    all = params[:all]
    if all.nil? || all != true
      @events = Event.where("rsvp_close >= :current", { current: Date.today })
    else
      @events = Event.all
    end
    if @events.nil?
      @events = []
    end
    @events
  end

  def get_my_events
    events = get_events
    current_events = []
    events.each do |event|
      current_events.push event.id
    end
    logger.info "current events => #{current_events}"

    @my_registrations = []
    @my_events = []

    if user_signed_in?
      user_events = UserEvent.where(user_id: current_user.id, event_id: current_events)
      user_events.each do |user_event|
        @my_registrations.push user_event
        @my_events.push user_event.event
      end
    end
  end

  # This will get a CSV of GMs to scenarios needed.
  def scenario_request_form
    # TODO: move somewhere?
    mapping = {}
    @event.unique_scenarios.each { |scenario| mapping[scenario] = [] }
    @event.game_masters.each do |gm|
      list = mapping[gm.scenario]
      reg = gm.user_event
      if list.any? { |check| check.user_event.id = reg.id }
        # Mark gm as requested
      else
        Rails.logger.info "Adding #{gm}"
        list << gm
      end
    end
    @game_masters = mapping.values.flatten
    respond_to do |format|
      format.json { render :scenario_request_form, status: :ok }
      # check for CSV, and make the default format, perhaps
      format.csv {
        send_data GameMaster.to_request_csv(@game_masters), filename: "scenario_request.csv"
      }
    end
  end

  # GET /events/1
  # GET /events/1.json
  def show
    if user_signed_in?
      @registration = @event.user_events.where(user_id: current_user.id).first
      if @registration
        @sessions = []
        @tables = []
        @gm_tables = []
        @gm_sessions = []
        @reg_tables = @registration.registration_tables
        @reg_tables_hash = {}

        @reg_tables.each do |reg_table|
          @tables << reg_table.table
          @sessions << reg_table.table.session
          @reg_tables_hash[reg_table.table] = reg_table
        end
        @game_masters = @registration.game_masters
        @game_masters.each do |gm|
          @gm_tables << gm.table
          @gm_sessions << gm.table.session
        end
      end
    end
  end

  # GET /events/new
  def new
    return unless restrict_to_admin

    @event = Event.new
    @user_event = UserEvent.new
  end

  # GET /events/1/edit
  def edit
    return unless restrict_to_admin
  end

  # POST /events
  # POST /events.json
  def create
    return unless restrict_to_admin
    @event = Event.new(event_params)

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    return unless restrict_to_admin
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    return unless restrict_to_admin
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_event
    @event = Event.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def event_params
    params.require(:event).permit(:name, :start, :end, :location, :rsvp_close, :prereg_ends, :charity,
                                  :prereg_price, :onsite_price, :info, :gm_volunteer_link, :tables_reg_offsite,
                                  :external_url, :event_number, :online_sales_end, :online, :in_person,
                                  :chat_server, :chat_server_url, :optional_fee, :gm_self_select, :gm_select_only,
                                  :gm_signup)
  end

end
