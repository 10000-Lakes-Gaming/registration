# frozen_string_literal: true

json.array!(@tables) do |table|
  json.extract! table, :id, :session_id, :scenario_id, :max_players
  json.url table_url(table, format: :json)
end
