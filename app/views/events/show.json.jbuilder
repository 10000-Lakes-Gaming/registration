json.event do
  json.extract! @event, :id, :name, :location, :charity
  json.set! :start, @event.start.localtime.to_formatted_s(:long)
  json.set! :end, @event.end.localtime.to_formatted_s(:long)
  json.set! :price, number_to_currency(@event.price.to_i)
  json.session do
    json.array!(@event.sessions) do |session|
      json.extract! session, :id, :name, :start, :end

      json.tables do
        json.array!(session.tables) do |table|
          json.extract! table, :id, :long_name, :max_players, :gms_needed, :location, :premium, :price
          json.scenario do
            json.extract! table.scenario, :type_of, :game_system, :season, :scenario_number, :name, :long_name, :short_name
          end
          json.set! :player_count, table.registration_tables.count
          json.set! :gm_count, table.game_masters.count
          json.game_masters do
            json.array! table.game_masters do |gm|
              json.extract! gm.user_event.user, :name, :pfs_number, :email, :forum_username, :title, :gm_stars, :show_stars
            end
          end
        end
      end
    end
  end
end
