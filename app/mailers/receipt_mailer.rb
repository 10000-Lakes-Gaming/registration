# frozen_string_literal: true

class ReceiptMailer < ApplicationMailer
  default from: (ENV['GMAIL_SMTP_USERNAME']).to_s

  def event_registration_payment_email(user_event)
    @user_event = user_event
    @event      = @user_event.event
    @user       = @user_event.user

    @subject = "Payment Received for #{@event.name}"
    mail(to: @user.email, subject: @subject) do |format|
      format.html
      format.text
    end
  end

  def table_registration_payment_email(registration_table)
    @registration_table = registration_table
    @user_event         = @registration_table.user_event
    @event              = @user_event.event
    @user               = @user_event.user
    @table              = @registration_table.table

    @subject = "Payment Received for #{@table.long_name} at #{@event.name}"
    mail(to: @user.email, subject: @subject) do |format|
      format.html
      format.text
    end
  end

  def additional_payment_email(payment)
    @payment    = payment
    @user_event = @payment.user_event
    @event      = @user_event.event
    @user       = @user_event.user

    @subject = "Payment Received for #{payment.long_description} at #{@event.name}"
    mail(to: @user.email, subject: @subject) do |format|
      format.html
      format.text
    end
  end
end
