class ContactMailer < ApplicationMailer

  def contact_email(message)
    @message = message
    mail(from: @message.email, subject: @message.subject)
  end

  def session_reminder(message)
    @message = message
    mail(subject: @message.subject)
  end

end
