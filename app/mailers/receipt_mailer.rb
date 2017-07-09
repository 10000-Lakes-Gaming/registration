class ReceiptMailer < ApplicationMailer

  default from: "mn.pfs.reg@gmail.com"

  def event_registration_payment_email(user_event)
    @user_event = user_event
    @event      = @user_event.event
    @user       = @user_event.user

    @subject = "Payment Received for #{@event.name}"
    mail(to: @user.email, subject: @subject)
  end

  def table_registration_payment_email(registration_table)
    @registration_table = registration_table
    @user_event         = @registration_table.user_event
    @event              = @user_event.event
    @user               = @user_event.user
    @table              = @registration_table.table


    @subject = "Payment Received for #{@table.long_name} at #{@event.name}"
    mail(to: @user.email, subject: @subject)
  end
end
