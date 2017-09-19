class AdditionalPaymentPaymentController < ApplicationController

  before_action :get_payment

  def get_payment

    Rails.logger.info("My params are: #{params.inspect}")

    additional_payment = params[:additional_payment_id]
    Rails.logger.info "I have additional_payment_id  = #{additional_payment}"
    @payment = AdditionalPayment.find(additional_payment)
  end

  def new
  end

  def create
    # Amount in cents
    token = params[:stripeToken]

    charge = Stripe::Charge.create(
        :source      => token,
        :amount      => @payment.price,
        :description => "#{@payment.user_event.user.name} payment for #{@payment.long_description}",
        :currency    => 'usd'
    )

    @payment.payment_amount = charge.amount # Will be in cents, not dollars!
    @payment.payment_id     = charge.id
    @payment.payment_date   = Time.now
    @payment.save!

    # Need to create the email for this!
    @user_event = @payment.user_event
    # send email
    ReceiptMailer.table_registration_payment_email(@registration_table).deliver

    redirect_to @payment.user_event.event, notice: "Thank you! Payment has been received for #{@payment.long_description}"

  rescue Stripe::CardError => e
    flash[:error] = e.message
    # where do I really want this to go?
    redirect_to new_registration_payment_path [@event, @user_event]
  end


  # def get_registration_tables
  #   @registration_tables = @table.registration_tables
  # end

end