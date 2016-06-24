class UserEventsController < ApplicationController
  before_action :set_user_event, only: [:show, :edit, :update, :destroy]

  # GET /user_events
  # GET /user_events.json
  def index
    @user_events = UserEvent.all
  end

  # GET /user_events/1
  # GET /user_events/1.json
  def show
  end

  # GET /user_events/new
  def new
    @user_event = UserEvent.new
  end

  # GET /user_events/1/edit
  def edit
  end

  # POST /user_events
  # POST /user_events.json
  def create
    @user_event = UserEvent.new(user_event_params)

    respond_to do |format|
      if @user_event.save
        format.html { redirect_to @user_event, notice: 'User event was successfully created.' }
        format.json { render :show, status: :created, location: @user_event }
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
        format.html { redirect_to @user_event, notice: 'User event was successfully updated.' }
        format.json { render :show, status: :ok, location: @user_event }
      else
        format.html { render :edit }
        format.json { render json: @user_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_events/1
  # DELETE /user_events/1.json
  def destroy
    @user_event.destroy
    respond_to do |format|
      format.html { redirect_to user_events_url, notice: 'User event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_event
      @user_event = UserEvent.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_event_params
      params.require(:user_event).permit(:user_id, :event_id, :paid)
    end
end
