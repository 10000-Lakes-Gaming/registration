json.scenario_assignments @tables_by_scenario do |scenario, tables|
  json.set! :scenario, scenario.long_name
  table_count            = 0
  gm_needed_count        = 0
  gm_assigned_count      = 0
  gm_remaining_count     = 0
  player_needed_count    = 0
  player_assigned_count  = 0
  player_remaining_count = 0
  tables.each do |table|
    table_count            += table.gms_needed
    gm_needed_count        += table.gms_needed
    gm_assigned_count      += table.current_gms
    gm_remaining_count     += table.gms_short
    player_needed_count    += table.max_players
    player_assigned_count  += table.current_registrations
    player_remaining_count += table.remaining_seats
  end
  json.set! :table_count, table_count
  json.set! :gm_needed_count, gm_needed_count
  json.set! :gm_assigned_count, gm_assigned_count
  json.set! :gm_remaining_count, gm_remaining_count
  json.set! :player_needed_count, player_needed_count
  json.set! :player_assigned_count, player_assigned_count
  json.set! :player_remaining_count, player_remaining_count
x end