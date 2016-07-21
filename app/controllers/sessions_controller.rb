class SessionsController < ApplicationController
  before_action :set_session, only: [:show, :edit, :update, :destroy]
  before_filter :get_event

  def get_event
    @event = Event.find(params[:event_id])
  end


  def prevent_non_admin
    unless current_user.admin?
      redirect_to events_path
    end
  end


  # GET /sessions
  # GET /sessions.json
  def index
    prevent_non_admin
    @sessions = Session.all
  end

  # GET /sessions/1
  # GET /sessions/1.json
  def show
  end

  # GET /sessions/new
  def new
    prevent_non_admin
    @session = Session.new
  end

  # GET /sessions/1/edit
  def edit
    prevent_non_admin
  end

  # POST /sessions
  # POST /sessions.json
  def create
    prevent_non_admin
    @session = @event.sessions.new(session_params)

    respond_to do |format|
      if @session.save
        format.html { redirect_to [@event, @session], notice: 'Session was successfully created.' }
        format.json { render :show, status: :created, location: [@event, @session] }
      else
        format.html { render :new }
        format.json { render json: @session.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sessions/1
  # PATCH/PUT /sessions/1.json
  def update
    prevent_non_admin
    respond_to do |format|
      if @session.update(session_params)
        format.html { redirect_to [@event, @session], notice: 'Session was successfully updated.' }
        format.json { render :show, status: :ok, location: [@event, @session] }
      else
        format.html { render :edit }
        format.json { render json: @session.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sessions/1
  # DELETE /sessions/1.json
  def destroy
    prevent_non_admin
    @session.destroy
    respond_to do |format|
      format.html { redirect_to sessions_url, notice: 'Session was successfully destroyed.' }
      format.json { head :no_content }
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
