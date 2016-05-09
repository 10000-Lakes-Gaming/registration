json.array!(@events) do |event|
  json.extract! event, :id, :name, :start, :end, :location
  json.url event_url(event, format: :json)
end
