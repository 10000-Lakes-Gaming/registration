class PaymentReminderController < ApplicationController
  before_filter :restrict_to_admin
  before_action :get_event, :get_users

  def get_event
    @event = Event.find(params[:event_id])
  end

  def get_users
    # @users = get_admin_users
    @user_events = UserEvent.where(event_id: @event.id)
    # pull the users out of this
    @users = []
    @user_events.each do |user|
      unless user.paid?
        @users.push user.user
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
    @message.subject = "Time is running out to pre-register for " + @event.name
    @message.content = "This is my content"
    @message.name = @event.name

    emails = @users.collect(&:email).join(",")

    if @message.valid?
      ContactMailer.payment_reminder(@message, emails).deliver_now
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
