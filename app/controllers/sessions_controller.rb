class SessionsController < ApplicationController
  include ApplicationHelper
  before_action :get_event
  before_action :set_session, only: [:show, :edit, :update, :destroy]

  def get_event
    @event = Event.find(params[:event_id])
  end


  # GET /sessions
  # GET /sessions.json
  def index
    return unless restrict_to_hosts
    @sessions = Session.where(event_id: @event.id)
  end

  # GET /sessions/1
  # GET /sessions/1.json
  def show
    get_session_data(@session)
  end

  def get_session_data (session)
    @registration_tables = {}
    @gm_sessions         = init_gm_sessions
    @player_sessions     = init_player_sessions
    @rsvps               = @event.user_events


    @rsvps.each do |rsvp|
      player_tables = rsvp.registration_tables
      player_tables.each do |reg_table|
        if reg_table.table.session == session
          players = @player_sessions[reg_table.table]
          if players.nil?
            players                           = []
            @player_sessions[reg_table.table] = players
          end
          players.push reg_table.user_event.user
        end
      end # end player_tables iteration

      gm_tables = rsvp.game_masters
      gm_tables.each do |gm_table|
        if gm_table.table.session == session
          gms = @gm_sessions[gm_table.table]
          if gms.nil?
            gms                          = []
            @gm_sessions[gm_table.table] = gms
          end
          gms.push gm_table.user_event.user
        end
      end
    end

  end

  def init_player_sessions
    @player_sessions = {}
    @session.tables.each do |table|
      @player_sessions[table] = []
    end
    @player_sessions
  end

  def init_gm_sessions
    @gm_sessions = {}
    @session.tables.each do |table|
      @gm_sessions[table] = []
    end
    @gm_sessions
  end

  # GET /sessions/new
  def new
    return unless restrict_to_hosts
    @session = Session.new
  end

  # GET /sessions/1/edit
  def edit

    return unless restrict_to_hosts
  end

  # POST /sessions
  # POST /sessions.json
  def create
    return unless restrict_to_hosts
    @session = @event.sessions.new(session_params)

    respond_to do |format|
      if @session.save
        format.html {redirect_to [@event, @session], notice: 'Session was successfully created.'}
        format.json {render :show, status: :created, location: [@event, @session]}
      else
        format.html {render :new}
        format.json {render json: @session.errors, status: :unprocessable_entity}
      end
    end
  end

  # PATCH/PUT /sessions/1
  # PATCH/PUT /sessions/1.json
  def update
    return unless restrict_to_hosts
    respond_to do |format|
      if @session.update(session_params)
        format.html {redirect_to [@event, @session], notice: 'Session was successfully updated.'}
        format.json {render :show, status: :ok, location: [@event, @session]}
      else
        format.html {render :edit}
        format.json {render json: @session.errors, status: :unprocessable_entity}
      end
    end
  end

  # DELETE /sessions/1
  # DELETE /sessions/1.json
  def destroy
    return unless restrict_to_hosts
    @session.destroy
    respond_to do |format|
      format.html {redirect_to sessions_url, notice: 'Session was successfully destroyed.'}
      format.json {head :no_content}
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_session
    @session = Session.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def session_params
    params.require(:session).permit(:event_id, :name, :start, :end)
  end
end
