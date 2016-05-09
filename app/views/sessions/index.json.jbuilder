json.array!(@sessions) do |session|
  json.extract! session, :id, :event_id, :name, :start, :end
  json.url session_url(session, format: :json)
end
