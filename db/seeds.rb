# frozen_string_literal: true

User.create(
  email: 'normaluser@mail.com',
  password: '123456789',
  role: 'none'
)

User.create(
  email: 'adminuser@gmail.com',
  password: '123456789',
  role: 'admin'
)

100.times do
  User.create(
    email: Faker::Internet.unique.email,
    password: '123456789',
    role: User::ROLES.sample
  )
end

@first_admin = User.where(role: 'admin').first.id
500.times do
  Movie.create(
    name: Faker::Books::Dune.quote + ' ' + Faker::Books::Dune.quote,
    description: Faker::Movies::PrincessBride.quote,
    price_rental: rand(0.01..99.99),
    price_sale: rand(0.01..99.99),
    stock_sale: rand(1..25),
    stock_rental: rand(1..25),
    availability: rand(0..1),
    user_id: @first_admin
  )
end
