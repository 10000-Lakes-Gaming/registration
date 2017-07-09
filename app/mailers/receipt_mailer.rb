class ReceiptMailer < ApplicationMailer

  default from: "mn.pfs.reg@gmail.com"
  default subject: "Payment Received"

  def event_registration_payment_email(user_event)
    @user_event = user_event
    mail(to: user_event.user.email)
  end
end
