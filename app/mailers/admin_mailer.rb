class AdminMailer < ApplicationMailer

  def cotn_gm_request_email(message)
    @previous = message.email_list

    # send an email to each individual
    message.email_list.each do |email|
      mail(subject: message.subject, to: email) do |format|
        @user = User.where(email: email).first
        puts "Sending to #{user.full_name}"
        format.html
        format.text
      end
    end
  end
end
