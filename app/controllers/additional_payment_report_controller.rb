class AdditionalPaymentReportController < ApplicationController
  include ApplicationHelper
  before_action :set_event

  def index
    return unless restrict_to_hosts

    @paid_payments = @event.additional_payments.reject { |payment| payment.unpaid? }
    @paid_payments.sort_by! { |payment| [payment.user_event, payment.category, payment.created_at]}

    @unpaid_payments = @event.additional_payments.select { |payment| payment.unpaid? }
    @unpaid_payments.sort_by! { |payment| [payment.user_event, payment.category, payment.created_at]}

    render :'additional_payments/report'
  end
end
