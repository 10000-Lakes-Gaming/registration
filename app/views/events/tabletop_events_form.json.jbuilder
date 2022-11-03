# frozen_string_literal: true
json.tables do
  json.table do
    json.array!(@event.tables) do |table|
      json.set! :event_type, 'Roleplaying Game'
      json.set! :event_type_id, @event.tabletop_event_type_code
      json.set! :name, table.schedule_name
      json.set! :description, table.scenario.description
      json.set! :more_information_url, table.scenario.paizo_url
    end
  end
end
