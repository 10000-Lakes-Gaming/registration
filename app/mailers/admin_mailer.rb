class AdminMailer < ApplicationMailer

  def cotn_gm_request_email(message)
    email_list = message.email_list.reject {|email| email.empty?}
    # send an email to each individual
    email_list.each do |email|
      @user = User.where(email: email).first
      puts "Sending to #{email}"
      mail(subject: message.subject, to: email) do |format|
        format.html
        format.text
      end
    end
  end
end
