class AdminEmailController < ApplicationController
  before_filter :restrict_to_admin

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
        logger.info "adding email " + email
        emails.push email
      end

      ContactMailer.admin_email(@message, emails).deliver_now
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
