class RegistrationTablesController < ApplicationController
  before_action :set_registration_table, only: [:show, :edit, :update, :destroy]
  before_filter :get_event, :get_session, :get_table, :get_registration_tables, :get_possible_players

  def prevent_non_admin
    unless current_user.admin?
      redirect_to events_path
    end
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
      # need to sort the gms
      # @tables = @session.tables.sort {|a,b| a <=> b}
      @possible_players = @possible_players.sort { |a, b| a <=> b }
    end
  end

  # GET /registration_tables
  # GET /registration_tables.json
  def index
    prevent_non_admin
  end

  # GET /registration_tables/1
  # GET /registration_tables/1.json
  def show
  end

  # GET /registration_tables/new
  def new
    @registration_table = RegistrationTable.new
    @user_event
    current_user.user_events.each do |rsvp|
      if rsvp.event == @event
        @user_event = rsvp
      end
    end

  end

  # GET /registration_tables/1/edit
  def edit
  end

  # POST /registration_tables
  # POST /registration_tables.json
  def create
    @registration_table = RegistrationTable.new(registration_table_params)
    respond_to do |format|
      if @registration_table.save
        format.html { redirect_to [@event], notice: 'Table was successfully added.' }
        format.json { render :show, status: :created, location: [@event] }
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
        format.html { redirect_to [@event, @session, @table, @registration_table], notice: 'Registration table was successfully updated.' }
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

  # Never trust parameters from the scary internet, only allow the white list through.
  def registration_table_params
    params.require(:registration_table).permit(:table_id, :user_event_id)
  end
end
