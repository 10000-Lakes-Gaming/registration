json.extract! event_host, :id, :start_date, :end_date, :user_id, :event_id, :created_at, :updated_at
json.url event_host_url(event_host, format: :json)
