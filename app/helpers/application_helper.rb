module ApplicationHelper

  def admin?
    user_signed_in? and current_user.admin?
  end

  def yes_no (value)
    value ? "Yes" : "No"
  end

  def receipts_exist?
    current_user.user_events.any? {|user_event| user_event.total_price > 0}
  end

  def unpaid_payments?
    current_user.user_events.any? {|user_event| user_event.additional_payments.any? {|payment| payment.unpaid?}}
  end

  def pending_payments
    unpaid_payments = []
    current_user.user_events.each do |user_event|
      user_event.additional_payments.each do |payment|
        if payment.unpaid?
          unpaid_payments << payment
        end
      end
    end
    unpaid_payments
  end

end
