class CotnEmailController < ApplicationController
  before_action :set_admins, :set_users

  def new
    @message = Message.new
    @message.subject = "Please volunteer to GM for MN-POP at Con of the North 2020"
  end

  def create
    return unless restrict_to_admin

    @message = Message.new(message_params)
    # defense, for a single real test

    AdminMailer.cotn_gm_request_email(@message).deliver_now
    redirect_to welcome_index_path, notice: "Your messages has been sent."
  end

  private

  def set_admins
    @admins = User.where(admin: true)
  end

  def set_users
    @users = User.all.sort
  end

  def message_params
    params.require(:message).permit(:email_list)
  end


end
