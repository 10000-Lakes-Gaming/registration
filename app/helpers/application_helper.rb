# frozen_string_literal: true

module ApplicationHelper
  def admin?
    user_signed_in? and current_user.admin?
  end

  def event_host?
    host = false
    if user_signed_in? && !@event.nil?
      current_user.event_hosts.each do |hosted_event|
        event = hosted_event.event
        host ||= (event.id == @event.id) if hosted_event.active?
      end
    end
    host || admin?
  end

  def game_master?
    current_user.gamemaster_for_event @event
  end

  def yes_no(value)
    value ? 'Yes' : 'No'
  end

  def receipts_exist?
    current_user.user_events.any? { |user_event| user_event.total_price.positive? }
  end

  def unpaid_payments?
    current_user.user_events.any? { |user_event| user_event.additional_payments.any?(&:unpaid?) }
  end

  def pending_payments
    unpaid_payments = []
    current_user.user_events.each do |user_event|
      user_event.additional_payments.each do |payment|
        unpaid_payments << payment if payment.unpaid?
      end
    end
    unpaid_payments
  end

  def self_select_allowed?(event)
    return false unless event.present?

    event.gm_self_select? && event.tables.any?(&:gm_self_select?)
  end

  def online_sales_closed?
    @event.online_sales_closed?
  end

  def optional_fee_list(elements = 20, increment = 5, starting = 0)
    (starting..(starting + (elements * increment))).step(increment).to_a
  end

  def donations_options(elements = 50, increment = 5, starting = 0)
    fees = optional_fee_list elements, increment, starting
    fees.map do |fee|
      [number_to_currency(fee), fee]
    end
  end

  def scenario_groups
    groups = {}
    @scenarios.each do |scenario|
      if groups.key? scenario.group
        group = groups[scenario.group]
      else
        group = ScenarioGroup.new
        group.group = scenario.group
      end
      group.scenarios.append(scenario)
      groups[group.group] = group
    end
    groups.values.sort
  end
end
