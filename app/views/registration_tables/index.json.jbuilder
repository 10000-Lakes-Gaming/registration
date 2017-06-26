json.array!(@registration_tables) do |registration_table|
  json.extract! registration_table, :id, :table, :user_event
  json.url registration_table_url(registration_table, format: :json)
end
