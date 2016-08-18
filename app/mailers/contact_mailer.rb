class ContactMailer < ApplicationMailer

  def contact_email(message)
    @message = message
    @from = @message.email
    mail(from: message.email, reply_to: message.email, subject: message.subject)
  end

  def admin_email(message)
    @message = message
    @from = @message.email
    @emails = @message.email_list.split
    mail(from: message.email, reply_to: message.email, subject: message.subject, bcc: @emails)
  end


  def session_reminder(message, emails)
    @message = message
    @emails = emails
    mail(subject: @message.subject, bcc: @emails)
  end

  def payment_reminder(message, emails)
    @message = message
    @emails = emails
    mail(subject: @message.subject, bcc: @emails)
  end

  def registration_reminder(message, emails)
    @message = message
    @emails = emails
    mail(subject: @message.subject, bcc: @emails)
  end

end
