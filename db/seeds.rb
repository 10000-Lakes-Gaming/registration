# frozen_string_literal: true

event_start = DateTime.now.change({ hour: 12, min: 0, sec: 0 }) + 1.month

event = Event.create!({ name: 'Initial Con!', start: event_start, end: event_start + 29.hours,
                        rsvp_close: event_start - 1.day, prereg_ends: event_start - 1.week,
                        online_sales_end: event_start - 5.days, tee_shirt_end: event_start - 10.days,
                        tee_shirt_price: 15, location: 'Online Event', online: true, in_person: true,
                        prereg_price: 10, onsite_price: 15, optional_fee: false, charity: false,
                        chat_server: 'My Discord', chat_server_url: 'http://www.somediscord.com' })

Session.create!([{ event_id: event.id, name: 'Session 1', start: event_start,
                   end: event_start + 5.hours },
                 { event_id: event.id, name: 'Session 2', start: event_start + 6.hours,
                   end: event_start + 11.hours },
                 { event_id: event.id, name: 'Session 3', start: event_start + 24.hours,
                   end: event_start + 29.hours }])

# rubocop:disable Layout/LineLength
Scenario.create!([{ type_of: 'Scenario', tier: '6-8', season: 7, scenario_number: 98, game_system: 'PFS',
                    name: 'Serpents Ire', description: 'This is the description', pregen_only: true,
                    hard_mode: false, author: 'John Compton',
                    paizo_url: 'http://paizo.com/products/btpy9lzy?Pathfinder-Society-Scenario-7-98-Serpents-Ire' },
                  { type_of: 'Scenario', tier: '4-6', season: 7, scenario_number: 99, game_system: 'PFS',
                    name: 'Through  Mailstrom Rift', description: 'A Pathfinder Society Special designed for 6th-leve...',
                    author: 'Linda Zayas-Palmer',
                    paizo_url: 'http://paizo.com/products/btpy9mbd?Pathfinder-Society-Scenario-799-Through-Maelstrom-Rift',
                    hard_mode: false, created_at: '2016-05-11 02:59:05', updated_at: '2016-05-11 02:59:05', pregen_only: true },
                  { type_of: 'Scenario', tier: '1-4', season: 1, scenario_number: 1, game_system: 'PFS2',
                    name: 'The Absalom Initiation', description: "A new era is beginning for the Pathfinder Society, with new recruits and new factions all excited to build connections and embark on grand adventures. The PCs are among these recruits invited to attend a welcoming party where they can meet both the old guard as well as the up-and-coming leaders. But the party's not all talk; the PCs learn of four exciting escapades in Absalom, through which they can kick off their adventuring careers!",
                    author: 'Lyz Liddell',
                    paizo_url: 'https://paizo.com/products/btq01znb?Pathfinder-Society-Scenario-101-The-Absalom-Initiation',
                    hard_mode: false, created_at: '2019-07-11 02:59:05', updated_at: '2019-07-11 02:59:05',
                    pregen_only: false },
                  { type_of: 'Quest', tier: '1-4', season: 1, scenario_number: 3, game_system: 'PFS2',
                    name: 'The Third Quest', description: 'Questing for a third time!',
                    author: 'Kate Baker',
                    hard_mode: false, created_at: '2019-07-11 02:59:05', updated_at: '2019-07-11 02:59:05',
                    pregen_only: false },
                  { type_of: 'Bounty', tier: '1', season: 2, scenario_number: 3, game_system: 'PFS2',
                    name: 'The Quicker Picker-Upper',
                    description: 'Wipe up that spill, find the magic towel! Not necessarily in that order',
                    author: 'Kate Baker',
                    hard_mode: false, created_at: '2019-07-11 02:59:05', updated_at: '2019-07-11 02:59:05', pregen_only: false }])
# rubocop:enable Layout/LineLength
Table.create!([{ session_id: 1, scenario_id: 1, online: true, max_players: 6, premium: true, prereg_price: 10,
                 onsite_price: 20, location: 'Room 1' },
               { session_id: 1, scenario_id: 2, online: true, max_players: 6, location: 'Room 2' },
               { session_id: 2, scenario_id: 1, online: true, max_players: 6, location: 'Room 1' },
               { session_id: 3, scenario_id: 2, online: true, max_players: 6, location: 'Room 1' }])

puts('Seeding users!')
user = User.create!({ name: 'Jack Brown', pfs_number: 788, admin: true, email: 'silbeg@gmail.com',
                      password: 'password', password_confirmation: 'password' })
User.create!([{ name: 'A. User', pfs_number: 1_234_687, admin: false, email: 'auser@gmail.com',
                password: 'password', password_confirmation: 'password' },
              { name: 'Ryan Blomquist', pfs_number: 8769, admin: true, email: 'blomquist.r@gmail.com',
                password: 'password', password_confirmation: 'password' }])

user_event = UserEvent.create!({ event: event, user: user, online: true, in_person: true, tee_shirt_size: 'XL' })

RegistrationTable.create!([{ user_event: user_event, table_id: 1, paid: true, payment_amount: 1000,
                             payment_id: 'PAYMENTID' }])
GameMaster.create!({ user_event: user_event, table_id: 3 })
