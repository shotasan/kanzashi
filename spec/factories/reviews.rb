FactoryBot.define do
  factory :review do
    original? { false }
    title { "MyString" }
    content { "MyText" }
    drank_on { "2019-06-08" }
    rating { 1 }
    bitter { 1 }
    acidity { 1 }
    rich { 1 }
    sweet { 1 }
    aroma { 1 }
    user
    after(:build) do |review|
      review.targets << FactoryBot.build(:target)
    end
  end
end
