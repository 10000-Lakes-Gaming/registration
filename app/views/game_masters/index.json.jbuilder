json.array!(@game_masters) do |game_master|
  json.extract! game_master, :id, :table_id, :user_event_id
  json.url game_master_url(game_master, format: :json)
end
