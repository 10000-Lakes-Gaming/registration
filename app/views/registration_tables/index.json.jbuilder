json.array!(@registration_tables) do |registration_table|
  json.extract! registration_table, :id, :table, :registration
  json.url registration_table_url(registration_table, format: :json)
end
