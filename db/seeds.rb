User.create!(name:  "Test Admin",
             email: "test@admin.com",
             password:              "password",
             password_confirmation: "password",
             admin: true,
             activated: true,
             activated_at: Time.zone.now)

users = User.order(:activated_at).take(20)
50.times do
  title = Faker::Lorem.sentence(1)
  tag_list = "test, test2"
  content = Faker::Lorem.sentence(4)
  users.each { |user| user.cheatsheets.create!(title: title, content: content, tag_list: tag_list, visibility: true) }
  users.each { |user| user.cheatsheets.create!(title: title + "private", content: content, tag_list: tag_list, visibility: false) }

end

99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@example.org"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now)
end


# Following relationships
users = User.all
user  = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }