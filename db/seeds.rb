# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
event = Event.create({name: 'Initial Con!', start: '2016-06-10 12:00', end: '2016-06-12 17:00', location: 'Fantasy Realms'})

sessions = Session.create([{event_id: 1, name: "Slot 1", start: '2016-06-10 12:00', end: '2016-06-10 17:00'}, {event_id: event.id, name: "Slot 2", start: '2016-06-10 18:00', end: '2016-06-10 23:00'}, event_id: event.id, name: "Slot 3", start: '2016-06-11 12:00', end: '2016-06-11 17:00'])

scenarios = Scenario.create([{scenario_type: "Scenario", season: 7, scenario_number: 98, name: "Serpents Ire", description: "This is the description", pregen_only: true, hard_mode: false, author: 'John Compton', paizo_url: 'http://paizo.com/products/btpy9lzy?Pathfinder-Society-Scenario-7-98-Serpents-Ire'},{scenario_type: "Scenario", season: 7, scenario_number: 99, name: "Through  Mailstrom Rift", description: "A Pathfinder Society Special designed for 6th-leve...", author: "Linda Zayas-Palmer", paizo_url: "http://paizo.com/products/btpy9mbd?Pathfinder-Society-Scenario-799-Through-Maelstrom-Rift", hard_mode: false, created_at: "2016-05-11 02:59:05", updated_at: "2016-05-11 02:59:05", pregen_only: true}])

table = Table.create([{session_id: 1, scenario_id: 1, max_players: 6 },{session_id: 1, scenario_id: 1, max_players: 6 },{session_id: 2, scenario_id: 1, max_players: 6},{session_id: 3, scenario_id: 1, max_players: 6}])
