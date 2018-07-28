users = [
  {first_name: 'Jon', last_name: 'Doe', email: 'e@example.com', password: 'Pa$$w0rd'},
  {first_name: 'Jane', last_name: 'Doe', email: 'e@example.com', password: 'Pa$$w0rd'}
]

users.each_with_index do |u, i|
  u.merge!({ id: 1 + i })
  User.create(u)
end

locations = [
  {address_1: "1234 main st", address_2: 'unit 3', city: 'miami', state: 'florida', postal_code: 33030},
  {address_1: "4321 town st", address_2: 'suite b', city: 'homestead', state: 'florida', postal_code: 23630}
]

locations.each_with_index do |u, i|
  u.merge!({ id: 1 + i })
  Location.create(u)
end

events = [
  {title: 'bday', description: 'jons bday party', location_id: 1, date: Date.today},
  {title: 'baby shower', description: 'janes baby shower', location_id: 2, date: (Date.today + 1.month)}
]

events.each_with_index do |u, i|
  u.merge!({ id: 1 + i })
  Event.create(u)
end

tasks = [
  {user_id: 1, status: false, description: 'get gift for janes baby shower'},
  {user_id: 2, status: false, description: 'order desserts for baby shower', event_id: 2}
]

tasks.each_with_index do |u, i|
  u.merge!({ id: 1 + i })
  Task.create(u)
end
