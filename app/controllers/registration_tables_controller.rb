# frozen_string_literal: true

class RegistrationTablesController < ApplicationController
  before_action :set_registration_table, only: %i[show edit update destroy]
  before_action :get_event, :get_session, :get_table, :get_registration_tables, :get_possible_players,
                :get_possible_tables

  def prevent_non_admin
    redirect_to events_path unless current_user.admin?
  end

  def get_table
    @table = Table.find(params[:table_id])
  end

  def get_session
    @session = @event.sessions.find(params[:session_id])
  end

  def get_event
    @event = Event.find(params[:event_id])
  end

  def get_registration_tables
    @registration_tables = @table.registration_tables
  end

  def get_possible_players
    @possible_players = []
    @not_available = []

    @event.user_events.each do |user_event|
      in_session = false
      user_event.registration_tables.each do |reg_table|
        in_session ||= reg_table.table.session == @session
      end
      user_event.game_masters.each do |game_master|
        in_session ||= game_master.table.session == @session
      end

      if in_session
        @not_available.push user_event
      else
        @possible_players.push user_event
      end
      # admin fix.
      if current_user.admin? && !@registration_table.nil?
        @possible_players.push @registration_table.user_event
        @not_available.delete @registration_table.user_event
      end

      @possible_players = @possible_players.sort { |a, b| a <=> b }
    end
  end

  def get_possible_tables
    @possible_tables = []
    # First, determine if this is an online or in person table -- we won't let them switch between modes
    tables = @table.online? ? @session.online_all_tables : @session.in_person_all_tables
    tables.each do |table|
      @possible_tables.push table unless table.full?
    end
  end

  # GET /registration_tables
  # GET /registration_tables.json
  def index
    prevent_non_admin
  end

  # GET /registration_tables/1
  # GET /registration_tables/1.json
  def show; end

  # GET /registration_tables/new
  def new
    @registration_table = RegistrationTable.new
    @user_event
    current_user.user_events.each do |rsvp|
      @user_event = rsvp if rsvp.event == @event
    end
  end

  # GET /registration_tables/1/edit
  def edit; end

  # POST /registration_tables
  # POST /registration_tables.json
  def create
    @registration_table = RegistrationTable.new(registration_table_params)

    # TODO: - is there a better way to do this?
    seat = RegistrationTable.where(table_id: @table.id).maximum('seat')
    if seat.nil?
      seat = 1
    else
      seat += 1
    end
    @registration_table.seat = seat

    respond_to do |format|
      if @registration_table.save
        if @registration_table.payment_ok?
          format.html { redirect_to [@event], notice: 'Table was successfully added.' }
        else
          format.html do
            redirect_to new_event_session_table_registration_table_table_payment_path(@event, @session, @table,
                                                                                      @registration_table)
          end
        end
      else
        format.html { render :new }
        format.json { render json: @registration_table.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /registration_tables/1
  # PATCH/PUT /registration_tables/1.json
  def update
    respond_to do |format|
      if @registration_table.update(registration_table_params)
        format.html do
          redirect_to [@event, @session, @table, @registration_table],
                      notice: 'Registration table was successfully updated.'
        end
        format.json { render :show, status: :ok, location: [@event, @session, @table, @registration_table] }
      else
        format.html { render :edit }
        format.json { render json: @registration_table.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /registration_tables/1
  # DELETE /registration_tables/1.json
  def destroy
    @registration_table.destroy
    respond_to do |format|
      format.html { redirect_to [@event], notice: 'RSVP was removed from table.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_registration_table
    @registration_table = RegistrationTable.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the allowlist through.
  def registration_table_params
    params.require(:registration_table).permit(:table_id, :user_event_id, :paid, :payment_amount, :payment_id,
                                               :payment_date)
  end
end
