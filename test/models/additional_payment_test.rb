require 'test_helper'

class AdditionalPaymentTest < ActiveSupport::TestCase

  test 'Unpaid payment is unpaid?' do
    payment = additional_payments(:unpaid_additional)
    assert payment.unpaid?
  end

  test 'Paid payment is not unpaid' do
    payment = additional_payments(:paid_payment)
    assert_not payment.unpaid?
  end

  test 'Donation amount is 38000!' do
    payment = additional_payments(:paid_payment)
    assert_equal (40000 - 2000), payment.donation_amount
  end

  test 'No Donation amount if unpaid' do
    payment = additional_payments(:unpaid_additional)
    assert_equal 0, payment.donation_amount
  end

  test 'No Donation amount if under market' do
    payment = additional_payments(:paid_but_under_market)
    assert_equal 0, payment.donation_amount
  end

end

