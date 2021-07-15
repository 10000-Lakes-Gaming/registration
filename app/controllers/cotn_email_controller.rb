class CotnEmailController < ApplicationController
  before_action :set_users

  def new
    @message = Message.new
    @message.subject = "Call for Vols for MN-POP at Con of the North 2020"
  end

  def create
    return unless restrict_to_admin

    @message = Message.new(message_params)
    # defense, for a single real test
    puts "Email list: #{@message.email_list.to_s}"
    @message.email_list.reject { |email| email.empty? }.each do |email|
      user = User.where(email: email).first
      if user.opt_out?
        puts "Not emailing #{user.formal_name} as they have opted out of emails."
      else
        @message.user = @user
        @message.email = email
        puts "Sending to #{user.formal_name} with email #{email}"
        puts "Another check.... #{user.email}"
        AdminMailer.cotn_gm_request_email(@message).deliver
      end
    end

    redirect_to welcome_index_path, notice: "Your messages has been sent."
  end

  private

  def set_users
    @users = User.where(opt_out: false).sort
  end

  def message_params
    params.require(:message).permit!
  end
end
