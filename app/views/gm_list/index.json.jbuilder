# frozen_string_literal: true

json.gm_list do
  json.array! @game_masters do |gm|
    json.set! :event_name, gm.table.session.event.name
    json.set! :session_name, gm.table.session.name
    json.set! :session_start, gm.table.session.start.localtime.to_formatted_s(:long)
    json.set! :session_end, gm.table.session.end.localtime.to_formatted_s(:long)
    json.set! :scenario, gm.table.scenario.long_name
    json.set! :gm_name, gm.user_event.user.name
    json.set! :gm_pfs_number, gm.user_event.user.pfs_number
    json.set! :gm_email, gm.user_event.user.email
    json.set! :gm_forum_username, gm.user_event.user.forum_username
    json.set! :gm_title, gm.user_event.user.title
    json.set! :table_assignment, gm.table_number unless gm.table_number.blank?
  end
end
