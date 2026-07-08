# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

if Rails.env.development?
  100.times do
    User.create(
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      dob: Faker::Date.between(from: '1990-01-01', to: '2020-01-01'),
      role: User.roles.keys.sample,
      gender: User.genders.keys.sample
    )
  end

  100.times do
    ids = User.ids
    Post.create(
      title: Faker::Book.title,
      user_id: ids.sample,
      body: Faker::Lorem.paragraph,
      posted_on: Faker::Date.between(from: '2000-01-01', to: '2020-01-01')
    )
  end
end