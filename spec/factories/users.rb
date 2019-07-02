FactoryBot.define do
  factory :user do
    name { 'テストユーザー'}
    sequence :email do |n|
      "test#{n}@example.com"
    end
    password { 'password' }
  end
end