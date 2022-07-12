# frozen_string_literal: true

class TablePaymentController < ApplicationController
  before_action :get_registration_table,
                def new
                  set_variables
                end

  def set_variables
    @user_event = @registration_table.user_event
    @event      = @user_event.event
    @table      = @registration_table.table
    @session    = @table.session
  end

  # localhost:3000/registration_tables/5/table_payment

  def create
    set_variables
    # Amount in cents
    amount = @table.price * 100
    token  = params[:stripeToken]

    charge = Stripe::Charge.create(
      source: token,
      amount:,
      description: "#{@user_event.user.name} payment for #{@table.name}",
      currency: 'usd'
    )

    @registration_table.paid           = true
    @registration_table.payment_amount = charge.amount # Will be in cents, not dollars!
    @registration_table.payment_id     = charge.id
    @registration_table.payment_date   = Time.now
    @registration_table.save!

    @user_event = @registration_table.user_event
    # send email
    ReceiptMailer.table_registration_payment_email(@registration_table).deliver

    redirect_to @event, notice: "Thank you! Payment has been received for #{@table.long_name}"
  rescue Stripe::CardError => e
    flash[:error] = e.message
    # where do I really want this to go?
    redirect_to new_registration_payment_path [@event, @user_event]
  end

  private

  def get_registration_table
    @registration_table = RegistrationTable.find(params[:registration_table_id])
  end

  def get_registration_tables
    @registration_tables = @table.registration_tables
  end
end
