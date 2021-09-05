# Create a main sample user.
User.create!(name: "phanvanluc",
             email: "vanlucbs1997@gmail.com",
             date_of_birth: "09-07-1997",
             phone_number: "0762530355",
             address: "Hokkaido, Japan",
             password: "123456",
             password_confirmation: "123456",
             admin: true)
             
# Generate a bunch of additional users. 
99.times do |n| 
  name = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name: name,
               email: email,
               date_of_birth: "09-09-1999",
               phone_number: "0389845000",
               address: "Hokkaido, Japan",
               password: password,
               password_confirmation: password)
end
