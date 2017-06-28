class RegistrationPaymentController < ApplicationController

  before_action :get_event, :get_registration

  def get_registration
    @user_event = UserEvent.find(params[:user_event_id])
  end

  def new
  end

  def create
    # Amount in cents
    @amount = @event.price * 100

    customer = Stripe::Customer.create(
        :email  => params[:stripeEmail],
        :source => params[:stripeToken]
    )

    charge = Stripe::Charge.create(
        :customer    => customer.id,
        :amount      => @amount,
        :description => "#{@user_event.user.name} payment for #{@event.name}",
        :currency    => 'usd'
    )

    logger.info "I have a charge #{charge}"
    logger.info "The charge ID is #{charge.id} and it was in the amount of #{charge.amount / 100}"

    @user_event.paid = true
    @user_event.payment_amount = charge.amount # Will be in cents, not dollars!
    @user_event.payment_id = charge.id
    @user_event.save!

  rescue Stripe::CardError => e
    flash[:error] = e.message
    # where do I really want this to go?
    redirect_to new_registration_payment_path [@event, @user_event]
  end


end