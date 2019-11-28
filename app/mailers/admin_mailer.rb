class AdminMailer < ApplicationMailer

  def cotn_gm_request_email(message)
    message.subject = 'Call for Vols for MN-POP at Con of the North 2020' if message.subject.blank?
    # send an email to each individual
    message.email_list.reject { |email| email.empty? }.each do |email|
      mail(subject: message.subject, to: email) do |format|
        @user = User.where(email: email).first
        puts "Sending to #{@user.formal_name}"
        format.html
        format.text
      end
    end
  end
end
