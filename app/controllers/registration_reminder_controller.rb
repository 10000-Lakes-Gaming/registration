class RegistrationReminderController < ApplicationController
  before_action :restrict_to_admin
  before_action :get_event, :get_users

  def get_event
    @event = Event.find(params[:event_id])
  end

  def get_users
    all_users = User.all
    @users = []
    # check each user to see if they are registered for the event.
    all_users.each do |user|
      registered = false
      user.user_events.each do |user_event|
        registered = registered || user_event.event == @event
      end
      unless registered
        @users.push user
      end
    end

    # sort the users
    @users = @users.sort { |a, b| a <=> b }
  end

  def new

  end

  def update
    @message = Message.new
    @message.email = current_user.email
    @message.subject = @event.name + " Registration Reminder Message"
    @message.content = "This is my content"
    @message.name = @event.name

    emails = @users.collect(&:email).join(",")

    if @message.valid?
      ContactMailer.registration_reminder(@message, emails).deliver_now
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
