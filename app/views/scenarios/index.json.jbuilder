json.array!(@scenarios) do |scenario|
  json.extract! scenario, :id, :scenario_type, :season, :scenario_number, :name, :description, :author, :paizo_url, :hard_mode
  json.url scenario_url(scenario, format: :json)
end
