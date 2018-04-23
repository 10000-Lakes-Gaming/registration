class EventHostsController < ApplicationController
  before_action :set_event_host, only: [:show, :edit, :update, :destroy]
  before_action :get_event
  before_action :get_users

  # GET /event_hosts
  # GET /event_hosts.json
  def index
     @event_hosts = EventHost.where(event_id: @event.id)
  end

  # GET /event_hosts/1
  # GET /event_hosts/1.json
  def show
  end

  # GET /event_hosts/new
  def new
    @event_host = EventHost.new
  end

  # GET /event_hosts/1/edit
  def edit
  end

  # POST /event_hosts
  # POST /event_hosts.json
  def create
    # @event_host = EventHost.new(event_host_params)

    @event_host = @event.event_hosts.new(event_host_params)

    respond_to do |format|
      if @event_host.save
        format.html {redirect_to [@event,@event_host], notice: 'Event host was successfully created.'}
        format.json {render :show, status: :created, location: [@event,@event_host]}
      else
        format.html {render :new}
        format.json {render json: @event_host.errors, status: :unprocessable_entity}
      end
    end
  end

  # PATCH/PUT /event_hosts/1
  # PATCH/PUT /event_hosts/1.json
  def update
    respond_to do |format|
      if @event_host.update(event_host_params)
        format.html {redirect_to [@event,@event_host], notice: 'Event host was successfully updated.'}
        format.json {render :show, status: :ok, location: [@event,@event_host]}
      else
        format.html {render :edit}
        format.json {render json: @event_host.errors, status: :unprocessable_entity}
      end
    end
  end

  # DELETE /event_hosts/1
  # DELETE /event_hosts/1.json
  def destroy
    # Better is to set the date to be yesterday?
    # @event_host.destroy


    respond_to do |format|
      format.html {redirect_to events_path, notice: 'Event host was successfully destroyed.'}
      format.json {head :no_content}
    end
  end

  private

  def get_users
    @users = User.all.order(:name)
  end

  def get_event
    @event = Event.find(params[:event_id])
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_event_host
    @event_host = EventHost.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def event_host_params
    params.require(:event_host).permit(:start_date, :end_date, :user_id, :event_id)
  end
end
