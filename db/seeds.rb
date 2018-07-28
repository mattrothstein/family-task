users = [
  {first_name: 'Jon', last_name: 'Doe', email: 'e@example.com'},
  {first_name: 'Jane', last_name: 'Doe', email: 'e@example.com'}
]

users.each_with_index do |u, i|
  u.merge!({ id: 10+i, password: "blah" })
  User.create(u)
end
