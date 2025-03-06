# Clear existing data
# Remove all records from the Guest, Event, and User tables to ensure fresh data
Guest.destroy_all
Event.destroy_all
User.destroy_all

# Create users
puts "Start Seeding Users"

# Create Alice as a user
alice = User.create!(
  first_name: "Alice",
  last_name: "Smith",
  email: "alice@example.com",
  password: "password123"
)

# Create Bob as a user
bob = User.create!(
  first_name: "Bob",
  last_name: "Johnson",
  email: "bob@example.com",
  password: "password123"
)

# Create Charlie as a user
charlie = User.create!(
  first_name: "Charlie",
  last_name: "Brown",
  email: "charlie@example.com",
  password: "password123"
)

# Create Dana as a user
dana = User.create!(
  first_name: "Dana",
  last_name: "Davis",
  email: "dana@example.com",
  password: "password123"
)

puts "Seeded Users Successfully!"

# Create events
puts "Start Seeding Events"

# Create Alice's Birthday Party event
event1 = Event.create!(
  title: "Alice's Birthday Party",
  start_date: Time.now + 1.day,
  end_date: Time.now + 1.day + 3.hours,
  start_time: Time.now + 1.day + 2.hours,
  end_time: Time.now + 1.day + 5.hours,
  location: "Alice's House",
  user_id: alice.id, # Set Alice as the event organizer
  description: "A fun birthday party!"
)

# Create Bob's Networking Event
event2 = Event.create!(
  title: "Bob's Networking Event",
  start_date: Time.now + 2.days,
  end_date: Time.now + 2.days + 3.hours,
  start_time: Time.now + 2.days + 1.hours,
  end_time: Time.now + 2.days + 4.hours,
  location: "Bob's Office",
  user_id: bob.id, # Set Bob as the event organizer
  description: "A networking event for professionals."
)

puts "Seeded Events Successfully!"

# Add guests to events
puts "Start Seeding Guests"

# Add guests to Alice's Birthday Party (event1)
Guest.create!(
  user: alice, # Alice is the event creator and admin
  event: event1,
  role: "admin",
  rsvp_status: "accepted", # Alice has accepted the invite
  party_size: 1
)
Guest.create!(
  user: charlie, # Charlie is a guest at Alice's party
  event: event1,
  role: "guest",
  rsvp_status: "pending", # Charlie hasn't responded yet
  party_size: 1
)
Guest.create!(
  user: dana, # Dana is a guest at Alice's party
  event: event1,
  role: "guest",
  rsvp_status: "accepted", # Dana has accepted the invite
  party_size: 2 # Dana is bringing a plus one
)

# Add guests to Bob's Networking Event (event2)
Guest.create!(
  user: bob, # Bob is the event creator and admin
  event: event2,
  role: "admin",
  rsvp_status: "accepted", # Bob has accepted his own event
  party_size: 1
)
Guest.create!(
  user: charlie, # Charlie is a guest at Bob's networking event
  event: event2,
  role: "guest",
  rsvp_status: "accepted", # Charlie has accepted the invite
  party_size: 1
)
Guest.create!(
  user: alice, # Alice is a guest at Bob's event
  event: event2,
  role: "guest",
  rsvp_status: "declined", # Alice has declined the invite
  party_size: 1
)

puts "Seeded Guests Successfully!"
puts "Seeding Completed!"
