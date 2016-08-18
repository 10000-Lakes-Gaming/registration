class AdminEmailController < ApplicationController
  before_filter :restrict_to_admin

  def new
    @message = Message.new
  end


  def create
    @message = Message.new(message_params)
    if @message.valid?
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
    params.require(:event).permit(:email_list, :subject, :name, :content)
  end

end
