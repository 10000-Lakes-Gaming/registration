class RegistrationPaymentController < ApplicationController

  before_action :get_user_event, :get_event

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

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to new_registration_payment_path [@event, @user_event]
  end

end