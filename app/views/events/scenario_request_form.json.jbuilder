# frozen_string_literal: true

json.gamemasters do
  json.game_master do
    json.array!(@game_masters) do |gm|
      json.set! :gm_name, gm.user_event.user.name
      json.set! :gm_email, gm.user_event.user.email
      json.set! :user_event_id, gm.user_event.user.id
      json.set! :gm_id, gm.id
      json.set! :forum_username, gm.user_event.user.forum_username
      json.set! :scenario_pzo_number, gm.scenario.catalog_number
      json.set! :scenario_name, gm.scenario.long_name
      json.set! :blank, ' '
      json.set! :convention_name, gm.user_event.event.name
    end
  end
end
