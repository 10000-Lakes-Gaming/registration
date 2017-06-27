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

  rescue Stripe::CardError => e
    flash[:error] = e.message
    # where do I really want this to go?
    redirect_to new_registration_payment_path [@event, @user_event]
  end


end