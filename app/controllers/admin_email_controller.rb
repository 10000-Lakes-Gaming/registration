class AdminEmailController < ApplicationController
  before_action :restrict_to_admin

  def new
    @message = Message.new
  end


  def create
    @message = Message.new(message_params)
    if @message.valid?
      # let's parse here.
      email_list = @message.email_list
      logger.info "Found email list => " + email_list
      emails = []
      email_list.split.each do |email|
        user = User.where(email: email).first
        emails.push email unless (email.blank? || user.opt_out?)
      end

      ContactMailer.admin_email(@message, emails).deliver
      redirect_to welcome_index_path, notice: "Your messages has been sent."
    else
      flash[:alert] = "An error occurred while delivering this message."
      render :new
    end
  end

  private
# Use callbacks to share common setup or constraints between actions.

  def message_params
    params.require(:message).permit(:email_list, :subject, :name, :content, :email)
  end

end
