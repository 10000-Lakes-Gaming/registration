class TablesController < ApplicationController
  before_action :set_table, only: [:show, :edit, :update, :destroy]
  before_action :get_event, :get_session, :get_scenarios

  def get_scenarios
    @scenarios = Scenario.all
  end

  def get_session
    @session = @event.sessions.find(params[:session_id])
  end

  def get_event
    @event = Event.find(params[:event_id])
  end

  def get_gms
    @gms = @table.game_masters
  end

  def prevent_non_admin
    unless current_user.admin?
      redirect_to events_path
    end
  end

  # GET /tables
  # GET /tables.json
  def index
    @tables = @session.tables.sort { |a, b| a <=> b }
  end

  # GET /tables/1
  # GET /tables/1.json
  def show
    @scenario = @table.scenario
    # let's clean up bad registrations.
    @table.registration_tables.each do |reg_table|
      # if reg_table.user_event.nil? || reg_table.table.nil?
      if reg_table.user_event.nil?
        @table.registration_tables - [reg_table]
        reg_table.destroy
      end
    end
  end

  # GET /tables/new
  def new
    prevent_non_admin
    @table = Table.new
    # Default this based on if there is an online component
    @table.online = @event.online
  end

  # GET /tables/1/edit
  def edit
    prevent_non_admin
  end

  # POST /tables
  # POST /tables.json
  def create
    prevent_non_admin
    @table = @session.tables.new(table_params)

    respond_to do |format|
      if @table.save
        format.html { redirect_to [@event, @session, @table], notice: 'Table was successfully created.' }
        format.json { render :show, status: :created, location: [@event, @session, @table] }
      else
        format.html { render :new }
        format.json { render json: @table.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tables/1
  # PATCH/PUT /tables/1.json
  def update
    prevent_non_admin
    respond_to do |format|
      if @table.update(table_params)
        format.html { redirect_to [@event, @session, @table], notice: 'Table was successfully updated.' }
        format.json { render :show, status: :ok, location: [@event, @session, @table] }
      else
        format.html { render :edit }
        format.json { render json: @table.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tables/1
  # DELETE /tables/1.json
  def destroy
    prevent_non_admin
    @table.destroy
    respond_to do |format|
      format.html { redirect_to event_session_tables_url, notice: 'Table was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_table
    @table = Table.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def table_params
    params.require(:table).permit(:session_id, :scenario_id, :max_players, :gms_needed, :gm_self_select, :raffle, :core, :disabled, :location, :premium, :prereg_price, :onsite_price, :non_pfs, :information, :online)
  end
end
