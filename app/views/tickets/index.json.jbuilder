# frozen_string_literal: true

json.array!(@tickets) do |ticket|
  # json.extract! ticket, :id, :table, :user_event
  json.set! :registration_number, ticket.registration_number
  json.set! :ticket_number, ticket.seat
  json.set! :total_tickets, ticket.table.max_players
  json.set! :event, ticket.event
  json.set! :session, ticket.session
  json.set! :session_start_time, ticket.session_start_time
  json.set! :scenario, ticket.scenario
  json.set! :player, ticket.player
  json.set! :pfs_number, ticket.pfs_number
  json.set! :price, ticket.ticket_price
end
