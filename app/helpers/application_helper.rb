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

  def sorted_user_tables (user_event)
    # sort the sessions by start time.
    @sessions       = user_event.event.sessions
    @table_sessions = {}

    @sessions.each do |session|
      @table_sessions[session] = nil
    end

    user_event.registration_tables.each do |reg_table|
      session                  = reg_table.table.session
      @table_sessions[session] = reg_table
    end
    user_event.game_masters.each do |game_master|
      session                  = game_master.table.session
      @table_sessions[session] = game_master
    end
  end


end
