# frozen_string_literal: true

json.array!(@scenarios) do |scenario|
  json.extract! scenario, :id, :game_system, :type_of, :season, :scenario_number, :name, :description, :author,
                :paizo_url, :hard_mode, :pregen_only, :retired, :evergreen
  json.url scenario_url(scenario, format: :json)
end
