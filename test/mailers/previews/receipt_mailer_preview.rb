# Preview all emails at http://localhost:3000/rails/mailers/receipt_mailer
class ReceiptMailerPreview < ActionMailer::Preview


  def event_registration_payment_email
    setup_user_event
    ReceiptMailer.event_registration_payment_email @user_event
  end

  def table_registration_payment_email
    setup_user_event
    add_table_to_event
    ReceiptMailer.table_registration_payment_email @registration_table
  end

  def additional_payment_email
    setup_user_event
    add_payment_to_event
    ReceiptMailer.additional_payment_email @payment
  end

  private
  def setup_user_event
    @event                     = Event.new
    @event.name                = 'Receipt Test Event'
    @event.prereg_price        = 20
    @user                      = User.first
    @user_event                = UserEvent.new
    @user_event.user           = @user
    @user_event.event          = @event
    @user_event.payment_amount = 2000
    @user_event.paid           = true
    @user_event.payment_id     = 'Event_Payment_ID'
    @user_event.payment_date   = 1.hour.ago
  end

  def add_payment_to_event
    @payment                = AdditionalPayment.new
    @payment.category       = "Auction"
    @payment.description    = "A napkin signed by Venture-Captain Jack Brown!"
    @payment.market_price   = 100
    @payment.charitable_donation = true
    @payment.payment_price  = 10000
    @payment.payment_amount = 10000
    @payment.payment_date   = Time.now
    @payment.payment_id     = 'An auction payment ID'
    @payment.user_event     = @user_event
    @user_event.additional_payments << @payment
  end

  def add_table_to_event
    scenario                 = Scenario.new
    scenario.type_of         = 'PFS'
    scenario.season          = 8
    scenario.scenario_number = 55
    scenario.name            = 'Coolest Adventure EVAR'

    session       = Session.new
    session.event = @event
    session.name  = 'My Session'
    @event.sessions << session

    @table          = session.tables.new
    @table.scenario = scenario
    @table.price    = 20

    @registration_table                = @table.registration_tables.new
    @registration_table.user_event     = @user_event
    @registration_table.payment_amount = 2000
    @registration_table.payment_id     = 'tab_pay_id_1234asd'
    @registration_table.payment_date   = Time.now
    @user_event.registration_tables << @registration_table

  end
end
