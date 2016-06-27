class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_filter :restrict_to_admin, except: [:show, :index]
  # GET /events
  # GET /events.json
  def index
    @events = Event.all

  end

  # GET /events/1
  # GET /events/1.json
  def show
    @registered = current_user.user_events.any? { |user_event| user_event.event_id == @event.id }
    @tables = []
    @sessions = []
    @event.sessions.each do |session|
      session.tables.each do |table|
        table.registration_tables.each do |reg_table|
          if reg_table.user_event.user_id == current_user.id
            @tables << reg_table.table
            @sessions << session
          end
        end
      end
    end

  end

  # GET /events/new
  def new
    @event = Event.new
    @user_event = UserEvent.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  # POST /events.json
  def create
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
    params.require(:event).permit(:name, :start, :end, :location)
  end

end
