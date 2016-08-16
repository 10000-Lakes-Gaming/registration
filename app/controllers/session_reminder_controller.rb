class SessionReminderController < ApplicationController
  before_filter :restrict_to_admin
  before_action :get_users

  def get_users
    # @users = get_admin_users
    # TODO - make this a value pulled in from the user
    @user_events = UserEvent.where(event_id: 3)
    # pull the users out of this
    @users = []
    @user_events.each do |user|
      @users.push user.user
    end
  end

  def get_admin_users
    admins = User.where(admin: true)
  end

  def new
    @message = Message.new
  end

  def create
    @message = Message.new(message_params)
    @message.email = "mn.pfs.reg@gmail.com"
    @message.subject = "Reminder Message"
    @message.content = "This is my content"
    @message.name = "SkålCon"

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

  def message_params
    # params.require().permit(:name, :email, :content, :subject)
  end
end
