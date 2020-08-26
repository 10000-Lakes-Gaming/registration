json.gamemasters do
  json.game_master do
    json.array!(@game_masters) do |gm|
      json.set! :name, gm.user_event.user.name
      json.set! :scenario, gm.scenario.long_name
    end
  end
end
