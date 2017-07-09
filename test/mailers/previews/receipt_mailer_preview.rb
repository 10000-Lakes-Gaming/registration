# Preview all emails at http://localhost:3000/rails/mailers/receipt_mailer
class ReceiptMailerPreview < ActionMailer::Preview
  def event_registration_payment_email
    @event            = Event.first
    @user             = User.first
    @user_event       = UserEvent.new
    @user_event.event = @event
    @user_event.user  = @user
    @user_event.payment_amount  = 2000
    @user_event.paid = true
    @user_event.payment_id = "TEST PAYMENT"
    ReceiptMailer.event_registration_payment_email @user_event
  end
end
