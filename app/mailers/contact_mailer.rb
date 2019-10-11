class ContactMailer < ApplicationMailer


  # for admins to send emails to users.
  def admin_email(message, emails)
    @message = message
    @emails  = emails
    # mail(subject: message.subject, bcc: @emails)
    # let's try iteration
    @emails.each do |email|
      mail(subject: message.subject, bcc: @emails)
    end
  end

  # this is the general contact form that folks can use.
  def contact_email(message)
    @message = message
    @from    = @message.email
    mail(from: message.email, reply_to: message.email, subject: message.subject)
  end

  # This is the message that lets folks know about the donation drive
  def donation_drive(message, email, event)
    @message = message
    @event = event
    mail(to: email, subject:@message.subject) do |format|
      format.html
      format.text
    end
  end

  # Email sent to GMs when they are added/dropped from a table
  def game_master(message, email, event, game_master, adding)
    @adding      = adding
    @message     = message
    @event       = event
    @game_master = game_master
    # add cc for registration
    mail(subject: @message.subject, to: email, bcc: ENV["GMAIL_SMTP_USERNAME"])
  end

  def payment_reminder(message, email, event)
    @event   = event
    @message = message
    mail(subject: @message.subject, to: email)
  end

  def registration_update(message, email, event, user_event)
    @event = event
    @user_event = user_event
    @message = message
    mail(subject: @message.subject, to: email)
  end

  def registration_reminder(message, email)
    @message = message
    mail(subject: @message.subject, to: email)
  end

  def session_reminder(message, email, event)
    @event   = event
    @message = message
    mail(subject: @message.subject, to: email)
  end

end


