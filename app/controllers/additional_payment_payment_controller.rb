# frozen_string_literal: true

class AdditionalPaymentPaymentController < ApplicationController
  before_action :get_payment

  def get_payment
    Rails.logger.info("My params are: #{params.inspect}")

    additional_payment = params[:additional_payment_id]
    Rails.logger.info "I have additional_payment_id  = #{additional_payment}"
    @payment = AdditionalPayment.find(additional_payment)
  end

  def new; end

  def create
    # Amount in cents
    token = params[:stripeToken]

    payment_message = "Processing Stripe payment #{@payment.id} #{@payment.long_description} for "
    payment_message += "#{@payment.user_event.user.name} for total value of #{@payment.price}"
    Rails.logger.info payment_message

    @user_event = @payment.user_event
    @event = @user_event.event

    charge = Stripe::Charge.create(
      source: token,
      amount: @payment.price,
      description: "#{@payment.user_event.user.name} payment for #{@payment.long_description}",
      currency: 'usd'
    )

    @payment.payment_amount = charge.amount # Will be in cents, not dollars!
    @payment.payment_id = charge.id
    @payment.payment_date = Time.now
    @payment.save!

    # send email
    ReceiptMailer.additional_payment_email(@payment).deliver

    redirect_to @event,
                notice: "Thank you! Payment has been received for #{@payment.long_description}"
  rescue Stripe::CardError => e
    message = "'Additional Payment error for #{@user_event.user.email} for #{@payment.long_description}'"
    Rails.logger.error "#{message}, error: #{e.message}"
    flash[:error] = e.message
    redirect_to event_user_event_additional_payment_path(@event, @user_event, @payment)
  end
end
