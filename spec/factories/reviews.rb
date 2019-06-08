FactoryBot.define do
  factory :review do
    original? { false }
    titile { "MyString" }
    content { "MyText" }
    image { "MyString" }
    drank_on { "2019-06-08" }
    rating { 1 }
    bitter { 1 }
    acidity { 1 }
    rich { 1 }
    sweet { 1 }
    aroma { 1 }
    user { nil }
  end
end
