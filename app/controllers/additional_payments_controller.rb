class AdditionalPaymentsController < ApplicationController
  before_action :set_additional_payment, only: [:show, :edit, :update, :destroy]

  # GET /additional_payments
  # GET /additional_payments.json
  def index
    @additional_payments = AdditionalPayment.all
  end

  # GET /additional_payments/1
  # GET /additional_payments/1.json
  def show
  end

  # GET /additional_payments/new
  def new
    @additional_payment = AdditionalPayment.new
  end

  # GET /additional_payments/1/edit
  def edit
  end

  # POST /additional_payments
  # POST /additional_payments.json
  def create
    @additional_payment = AdditionalPayment.new(additional_payment_params)

    respond_to do |format|
      if @additional_payment.save
        format.html {redirect_to @additional_payment, notice: 'Additional payment was successfully created.'}
        format.json {render :show, status: :created, location: @additional_payment}
      else
        format.html {render :new}
        format.json {render json: @additional_payment.errors, status: :unprocessable_entity}
      end
    end
  end

  # PATCH/PUT /additional_payments/1
  # PATCH/PUT /additional_payments/1.json
  def update
    respond_to do |format|
      if @additional_payment.update(additional_payment_params)
        format.html {redirect_to @additional_payment, notice: 'Additional payment was successfully updated.'}
        format.json {render :show, status: :ok, location: @additional_payment}
      else
        format.html {render :edit}
        format.json {render json: @additional_payment.errors, status: :unprocessable_entity}
      end
    end
  end

  # DELETE /additional_payments/1
  # DELETE /additional_payments/1.json
  def destroy
    @additional_payment.destroy
    respond_to do |format|
      format.html {redirect_to additional_payments_url, notice: 'Additional payment was successfully destroyed.'}
      format.json {head :no_content}
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_additional_payment
    @additional_payment = AdditionalPayment.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def additional_payment_params
    params.require(:additional_payment).permit(:category, :description, :charitable_donation, :market_price, :payment_price, :payment_amount, :payment_id, :payment_date, :user_event_id)
  end
end
