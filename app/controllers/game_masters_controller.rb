class GameMastersController < ApplicationController
  before_action :set_game_master, only: [:show, :edit, :update, :destroy]
  before_filter :get_event, :get_session, :get_table, :get_user_event, :get_possible_gms

  def prevent_non_admin
    unless current_user.admin?
      redirect_to events_path
    end
  end


  # GET /game_masters/1
  # GET /game_masters/1.json
  def show
  end

  # GET /game_masters/new
  def new
    prevent_non_admin
    @game_master = GameMaster.new
  end

  def get_possible_gms
    @possible_gms = []

    @event.user_events.each do |user_event|
      in_session = false
      user_event.registration_tables.each do |reg_table|
        in_session ||= reg_table.table.session == @session
      end
      user_event.game_masters.each do |game_master|
        in_session ||= game_master.table.session == @session
      end

      unless in_session
        @possible_gms.push user_event
      end
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

  def get_user_event
    # this only works in non-admin mode -- we'll need to figure this out later.
    # UserEvent.where(user_id: == current_user.id AND event_id: == @event.id)
    @user_event = UserEvent.find_by_event_id_and_user_id(params[:event_id], current_user.id)
  end


  # GET /game_masters
  # GET /game_masters.json
  def index
    prevent_non_admin
    @game_masters = GameMaster.all
  end

  # GET /game_masters/1/edit
  def edit
    prevent_non_admin
  end

  # POST /game_masters
  # POST /game_masters.json
  # TODO - can only admins add GMs?
  def create
    prevent_non_admin
    # TODO - do something if already regisered for table/session
    @game_master = GameMaster.new(game_master_params)
    respond_to do |format|
      if @game_master.save
        format.html { redirect_to [@event, @session, @table], notice: 'Game master was successfully added.' }
        format.json { render :show, status: :created, location: @game_master }
      else
        format.html { render :new }
        format.json { render json: @game_master.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /game_masters/1
  # PATCH/PUT /game_masters/1.json
  def update
    prevent_non_admin
    respond_to do |format|
      if @game_master.update(game_master_params)
        format.html { redirect_to @game_master, notice: 'Game master was successfully updated.' }
        format.json { render :show, status: :ok, location: @game_master }
      else
        format.html { render :edit }
        format.json { render json: @game_master.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /game_masters/1
  # DELETE /game_masters/1.json
  def destroy
    prevent_non_admin
    @game_master.destroy
    respond_to do |format|
      format.html { redirect_to [@event], notice: "#{@game_master.user_event.user.long_name} was removed as a Game Master from table." }
      format.json { head :no_content }
    end
  end


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_game_master
    @game_master = GameMaster.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def game_master_params
    params.require(:game_master).permit(:table_id, :user_event_id)
  end
end
