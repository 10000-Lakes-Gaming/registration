json.array!(@scenarios) do |scenario|
  json.extract! scenario, :id, :type_of, :season, :scenario_number, :name, :description, :author, :paizo_url, :hard_mode
  json.url scenario_url(scenario, format: :json)
end
