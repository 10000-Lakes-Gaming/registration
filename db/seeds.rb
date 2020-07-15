
event_start = DateTime.now.change({ hour: 12, min: 0, sec: 0 })

event = Event.create!({ name: 'Initial Con!', start: event_start, end: event_start + 29.hours,
                        rsvp_close: event_start - 1.day, prereg_ends: event_start - 1.week,
                        location: 'Fantasy Realms' })

sessions = Session.create!([{ event_id: event.id, name: "Session 1", start: event_start,
                              end: event_start + 5.hours },
                            { event_id: event.id, name: "Session 2", start: event_start + 6.hours,
                              end: event_start + 11.hours },
                            { event_id: event.id, name: "Session 3", start: event_start + 24.hours,
                              end: event_start + 29.hours }])

scenarios = Scenario.create!([{ type_of: "Scenario", tier: '6-8', season: 7, scenario_number: 98,
                                name: "Serpents Ire", description: "This is the description", pregen_only: true,
                                hard_mode: false, author: 'John Compton',
                                paizo_url: 'http://paizo.com/products/btpy9lzy?Pathfinder-Society-Scenario-7-98-Serpents-Ire' },
                              { type_of: "Scenario", tier: '4-6', season: 7, scenario_number: 99,
                                name: "Through  Mailstrom Rift", description: "A Pathfinder Society Special designed for 6th-leve...",
                                author: "Linda Zayas-Palmer",
                                paizo_url: "http://paizo.com/products/btpy9mbd?Pathfinder-Society-Scenario-799-Through-Maelstrom-Rift",
                                hard_mode: false, created_at: "2016-05-11 02:59:05", updated_at: "2016-05-11 02:59:05", pregen_only: true }])

tables = Table.create!([{ session_id: 1, scenario_id: 1, max_players: 6, premium: true, prereg_price: 10, onsite_price: 20 },
                        { session_id: 1, scenario_id: 2, max_players: 6 },
                        { session_id: 2, scenario_id: 1, max_players: 6 },
                        { session_id: 3, scenario_id: 2, max_players: 6 }])


puts("Seeding users!")
users = User.create!([{ name: "Jack Brown", pfs_number: 74294, admin: true, email: "silbeg@gmail.com",
                        password: 'password', password_confirmation: 'password' },
                      { name: "Keith Apperson", pfs_number: 124235, admin: true, email: "ziegrauros@gmail.com",
                        password: 'password', password_confirmation: 'password' },
                      { name: "Ryan Blomquist", pfs_number: 8769, admin: true, email: "blomquist.r@gmail.com",
                        password: 'password', password_confirmation: 'password' }])

userEvent = UserEvent.create!([{ event_id: 1, user_id: 1 }])

registration_tables = RegistrationTable.create!([{ user_event_id: 1, table_id: 1, paid: true, payment_amount: 1000, payment_id: 'PAYMENTID' },
                                                 { user_event_id: 1, table_id: 3 }])

additional_payments = AdditionalPayment.create!([{ user_event_id: 1, category: 'auction', description: 'A really neat thingie!',
                                                   charitable_donation: true, market_price: 2000, payment_price: 3000 },
                                                 { user_event_id: 1, category: 'auction', description: 'Another really neat thingie!',
                                                   charitable_donation: true, market_price: 2000, payment_price: 3000 },
                                                 { user_event_id: 1, category: 'auction', description: 'Yes, another really neat thingie!',
                                                   charitable_donation: true, market_price: 2000, payment_price: 3000 }])
