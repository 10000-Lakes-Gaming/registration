class ContactMailer < ApplicationMailer

  def contact_email(message)
    @message = message
    @from = @message.email
    mail(from: message.email, subject: message.subject)
  end

  def session_reminder(message, emails)
    @message = message
    @emails = emails
    mail(subject: @message.subject, bcc: @emails)
  end

end
