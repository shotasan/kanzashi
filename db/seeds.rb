# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'faker'

roasted_select_box = %w[ライトロースト シナモンロースト ミディアムロースト ハイロースト シティロースト フルシティロースト フレンチロースト イタリアンロースト]
grind_select_box = %w[極細挽き 細挽き 中細挽き 中挽き 粗挽き]

50.times {
  current_user = User.create!(name: Faker::Name.unique.name,
                              email: Faker::Internet.email,
                              password: 'password',
                              password_confirmation: 'password')

  3.times {
    current_user.beans.create!(user_id: User.last.id,
                               name: Faker::Coffee.blend_name,
                               country: Faker::Address.city,
                               plantation: Faker::Address.city)
  }

  review = current_user.reviews.build(title: Faker::Book.title[0..30],
                                      content: Faker::Coffee.notes,
                                      drank_on: Faker::Date.between(from: 1.year.ago, to: Date.today),
                                      rating: rand(1..5),
                                      bitter: rand(1..5),
                                      acidity: rand(1..5),
                                      rich: rand(1..5),
                                      sweet: rand(1..5),
                                      aroma: rand(1..5))

  rand(1..3).times {
    review.targets.build(bean_id: current_user.beans.sample.id,
                         roasted: roasted_select_box.sample,
                         roasted_on: Faker::Date.between(from: 1.year.ago, to: Date.today),
                         grind: grind_select_box.sample,
                         amount: rand(10..100))
  }
  review.save!
}