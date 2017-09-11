# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
event = Event.create!({name: 'Initial Con!', start: '2018-06-10 12:00', end: '2018-06-12 17:00',
                       rsvp_close: '2018-6-10 18:00', prereg_ends: '2018-06-09 17:00', location: 'Fantasy Realms'})

sessions = Session.create!([{event_id: event.id, name: "FRI12-17", start: '2018-06-10 12:00', end: '2018-06-10 17:00'},
                            {event_id: event.id, name: "FRI18-23", start: '2018-06-10 18:00', end: '2018-06-10 23:00'},
                            {event_id: event.id, name: "SAT12-17", start: '2018-06-11 12:00', end: '2018-06-11 17:00'}])

scenarios = Scenario.create!([{type_of:   "Scenario", tier: '6-8', season: 7, scenario_number: 98,
                               name:      "Serpents Ire", description: "This is the description", pregen_only: true,
                               hard_mode: false, author: 'John Compton',
                               paizo_url: 'http://paizo.com/products/btpy9lzy?Pathfinder-Society-Scenario-7-98-Serpents-Ire'},
                              {type_of:   "Scenario", tier: '4-6', season: 7, scenario_number: 99,
                               name:      "Through  Mailstrom Rift", description: "A Pathfinder Society Special designed for 6th-leve...",
                               author:    "Linda Zayas-Palmer",
                               paizo_url: "http://paizo.com/products/btpy9mbd?Pathfinder-Society-Scenario-799-Through-Maelstrom-Rift",
                               hard_mode: false, created_at: "2016-05-11 02:59:05", updated_at: "2016-05-11 02:59:05", pregen_only: true}])

tables = Table.create!([{session_id: 1, scenario_id: 1, max_players: 6, premium: true, prereg_price: 10, onsite_price: 20},
                        {session_id: 1, scenario_id: 2, max_players: 6},
                        {session_id: 2, scenario_id: 1, max_players: 6},
                        {session_id: 3, scenario_id: 2, max_players: 6}])


puts("Seeding users!")
users = User.create!([{name:     "Jack Brown", pfs_number: 74294, admin: true, email: "silbeg@gmail.com",
                       password: 'password', password_confirmation: 'password'},
                      {name:     "Keith Apperson", pfs_number: 124235, admin: true, email: "ziegrauros@gmail.com",
                       password: 'password', password_confirmation: 'password'}])

userEvent = UserEvent.create!([{event_id: 1, user_id: 1}])

registration_tables = RegistrationTable.create!([{user_event_id: 1, table_id: 1, paid: true, payment_amount: 1000, payment_id: 'PAYMENTID'},
                                                 {user_event_id: 1, table_id: 3}])

additional_payments = AdditionalPayment.create!([user_event_id: 1, category: 'auction', description: 'A really neat thingie!',
                                                charitable_donation: true, market_price: 2000, payment_price: 3000])