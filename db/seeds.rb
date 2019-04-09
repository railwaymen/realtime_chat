10.times do |i|
  i += 1
  User.where(id: i, email: "user#{i}@example.com", username: "user#{i}").first_or_create!(password: 'password')
end