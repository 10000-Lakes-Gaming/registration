require 'test_helper'

class AdditionalPaymentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    $disable_authentication = true
    @additional_payment = additional_payments(:one)
  end

  test "should get index" do
    get additional_payments_url
    assert_response :success
  end

  test "should get new" do
    get new_additional_payment_url
    assert_response :success
  end

  test "should create additional_payment" do
    skip
    assert_difference('AdditionalPayment.count') do
      post additional_payments_url, params: { additional_payment: { category: @additional_payment.category, description: @additional_payment.description, payment_amount: @additional_payment.payment_amount, payment_date: @additional_payment.payment_date, payment_id: @additional_payment.payment_id, price: @additional_payment.price, user_event_id: @additional_payment.user_event_id } }
    end

    assert_redirected_to additional_payment_url(AdditionalPayment.last)
  end

  test "should show additional_payment" do
    get additional_payment_url(@additional_payment)
    assert_response :success
  end

  test "should get edit" do
    get edit_additional_payment_url(@additional_payment)
    assert_response :success
  end

  test "should update additional_payment" do
    skip
    patch additional_payment_url(@additional_payment), params: { additional_payment: { category: @additional_payment.category, description: @additional_payment.description, payment_amount: @additional_payment.payment_amount, payment_date: @additional_payment.payment_date, payment_id: @additional_payment.payment_id, price: @additional_payment.price, user_event_id: @additional_payment.user_event_id } }
    assert_redirected_to additional_payment_url(@additional_payment)
  end

  test "should destroy additional_payment" do
    skip
    assert_difference('AdditionalPayment.count', -1) do
      delete additional_payment_url(@additional_payment)
    end

    assert_redirected_to additional_payments_url
  end
end
