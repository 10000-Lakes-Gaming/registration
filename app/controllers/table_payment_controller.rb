class TablePaymentController < ApplicationController

  before_action :get_event, :get_registration_table,

  def new
    @user_event = @registration_table.user_event
  end

# localhost:3000//events/3/sessions/4/tables/7/registration_tables/5/table_payment

  def create
    # Amount in cents
    amount = @table.price * 100
    token  = params[:stripeToken]
    # customer = Stripe::Customer.create(
    #     :email  => params[:stripeEmail],
    #     :source => params[:stripeToken]
    # )

    charge = Stripe::Charge.create(
        :source      => token,
        :amount      => amount,
        :description => "#{@user_event.user.name} payment for #{@table.name}",
        :currency    => 'usd'
    )

    @user_event.paid           = true
    @user_event.payment_amount = charge.amount # Will be in cents, not dollars!
    @user_event.payment_id     = charge.id
    @user_event.save!

  rescue Stripe::CardError => e
    flash[:error] = e.message
    # where do I really want this to go?
    redirect_to new_registration_payment_path [@event, @user_event]
  end

  private
  def get_registration_table
    @registration_table = RegistrationTable.find(params[:registration_table_id])
  end

  def get_table
    @table = Table.find(params[:table_id])
  end

  def get_session
    @session = @event.sessions.find(params[:session_id])
  end

  def get_event
    @event = Event.find(params[:event_id])
  end

  def get_registration_tables
    @registration_tables = @table.registration_tables
  end

end