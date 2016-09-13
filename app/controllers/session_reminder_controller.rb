class SessionReminderController < ApplicationController
  before_filter :restrict_to_admin
  before_action :get_event, :get_users

  def get_event
    @event = Event.find(params[:event_id])
  end

  def get_users
    # @users = get_admin_users
    # TODO - make this a value pulled in from the user
    @user_events = UserEvent.where(event_id: @event.id).limit(20).offset(20)
    # pull the users out of this
    @users = []
    @user_events.each do |user|
      @users.push user.user
    end
    # sort the users
    @users = @users.sort { |a, b| a <=> b }
  end

  def new

  end

  def update
    @message = Message.new
    @message.email = current_user.email
    @message.subject = "SkålCon Guest GM Raffles Presales end Wednesday at 5PM!"
    @message.content = "This is my content"
    @message.name = @event.name

    emails = @users.collect(&:email).join(",")

    if @message.valid?
      ContactMailer.session_reminder(@message, emails).deliver_now
      redirect_to welcome_index_path, notice: "Your messages has been sent."
    else
      flash[:alert] = "An error occurred while delivering this message."
      render :new
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.

  def message_params
    params.require(:event)
  end
end
