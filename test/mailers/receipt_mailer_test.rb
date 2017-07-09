require 'test_helper'

class ReceiptMailerTest < ActionMailer::TestCase
  test "Registration Payment sent" do
    user_event                = user_events(:normal_guy_my_event)
    user_event.payment_id     = "PaymentID"
    user_event.payment_amount = "2000"
    user_event.payment_id     = true


    email = ReceiptMailer.event_registration_payment_email(user_event).deliver_now
    assert_not_empty ActionMailer::Base.deliveries
  end


end
