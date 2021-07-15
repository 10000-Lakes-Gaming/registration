# frozen_string_literal: true

class AdditionalPaymentReportController < ApplicationController
  include ApplicationHelper
  before_action :set_event

  def index
    return unless restrict_to_hosts

    @paid_payments = @event.additional_payments.reject(&:unpaid?)
    @paid_payments.sort_by! { |payment| [payment.user_event, payment.category, payment.created_at] }

    @unpaid_payments = @event.additional_payments.select(&:unpaid?)
    @unpaid_payments.sort_by! { |payment| [payment.user_event, payment.category, payment.created_at] }

    @total_paid = @paid_payments.reduce(0) { |sum, payment| sum + payment.payment_amount }
    @total_pending = @unpaid_payments.reduce(0) { |sum, payment| sum + payment.payment_price }

    render :'additional_payments/report'
  end
end
