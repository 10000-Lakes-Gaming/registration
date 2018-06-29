class ContactMailer < ApplicationMailer

  def contact_email(message)
    @message = message
    @from    = @message.email
    mail(from: message.email, reply_to: message.email, subject: message.subject)
  end

  def admin_email(message, emails)
    @message = message
    @emails  = emails
    # mail(subject: message.subject, bcc: @emails)
    # let's try iteration
    @emails.each do |email|
      mail(subject: message.subject, bcc: @emails)
    end
  end


  def session_reminder(message, email, event)
    @event = event
    @message = message
    mail(subject: @message.subject, to: email)
  end

  def payment_reminder(message, email, event)
    @event   = event
    @message = message
    mail(subject: @message.subject, to: email)
  end

  def registration_reminder(message, email)
    @message = message
    mail(subject: @message.subject, to: email)
  end

  def game_master(message, email, event, game_master)
    @message = message
    @event = event
    @game_master = game_master
    # add cc for registration
    mail(subject: @message.subject, to: email)
  end

end
