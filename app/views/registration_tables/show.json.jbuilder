json.event do
  json.set! :event_name, @event.name
  json.set! :event_date, @event.date_range
end
json.ticket do
  json.set! :ticket_number, @registration_table.id
  json.set! :session, @session.name
  json.set! :session_start_time, @session.start.localtime.to_formatted_s(:long)
  json.set! :table, @table.name
  json.set! :location, @table.location
  json.set! :seat , @registration_table.seat
  json.set! :max, @registration_table.table.max_players
end
json.player do
  user = @registration_table.user_event.user
  json.set! :name, user.formal_name
  json.set! :pfs_number, user.pfs_number
  json.set! :registration, @registration_table.user_event.id
end
