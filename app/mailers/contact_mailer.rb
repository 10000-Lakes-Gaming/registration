# frozen_string_literal: true

class ContactMailer < ApplicationMailer
  # for admins to send emails to users.
  def admin_email(message, emails)
    @message = message
    # mail(subject: message.subject, bcc: @emails)
    # let's try iteration
    emails.each do |email|
      user = User.where(email:).first
      @message.user = user
      mail(subject: message.subject, to: email) unless email.blank? || user.opt_out?
    end
  end

  def email_players(message, table, user)
    @message = message
    @table = table
    email = user.email

    # we will put the players in the BCC list.
    # Also, we will bcc the registration email, so we have a copy.
    bcc = [ENV.fetch('GMAIL_SMTP_USERNAME', nil)]
    table.registration_tables.each do |signup|
      player = signup.user_event.user
      bcc.append player.email unless player.opt_out?
    end
    puts "BCC: #{bcc}"
    mail(from: email, to: email, bcc:, reply_to: email, subject: message.subject)
  end

  # this is the general contact form that folks can use.
  def contact_email(message)
    @message = message
    @from = @message.email
    mail(from: message.email, reply_to: message.email, subject: message.subject)
  end

  # This is the message that lets folks know about the donation drive
  def donation_drive(message, email, event)
    @message = message
    @event = event

    user = User.where(email:).first
    @message.user = user
    unless email.blank? || user.opt_out?
      mail(to: email, subject: @message.subject) do |format|
        format.html
        format.text
      end
    end
  end

  # Email sent to GMs when they are added/dropped from a table
  def game_master(message, email, event, game_master, adding, reminder = false)
    @adding = adding
    @reminder = reminder
    @message = message
    @event = event
    @game_master = game_master
    # add cc for registration
    mail(subject: @message.subject, to: email, bcc: ENV.fetch('GMAIL_SMTP_USERNAME', nil))
  end

  def participant(message, email, event, registration)
    @message = message
    @event = event
    @registration = registration

    mail(subject: @message.subject, to: email, bcc: ENV.fetch('GMAIL_SMTP_USERNAME', nil))
  end

  def payment_reminder(message, email, event)
    @event = event
    @message = message

    user = User.where(email:).first
    @message.user = user
    mail(subject: @message.subject, to: email) unless email.blank? || user.opt_out?
  end

  def registration_update(message, email, event, user_event)
    @event = event
    @user_event = user_event
    @message = message

    user = User.where(email:).first
    @message.user = user

    mail(subject: @message.subject, to: email) unless email.blank? || user.opt_out?
  end

  def registration_reminder(message, email)
    @message = message

    user = User.where(email:).first
    @message.user = user

    mail(subject: @message.subject, to: email) unless email.blank? || user.opt_out?
  end

  def session_reminder(message, email, event)
    @event = event
    @message = message

    user = User.where(email:).first
    @message.user = user
    mail(subject: @message.subject, to: email) unless email.blank? || user.opt_out?
  end

  def skalcon_announcement(message, user, event)
    @message = message
    @user = user
    @event = event

    mail(subject: @message.subject, to: user.email) unless user.opt_out? || user.email.blank?
  end
end
