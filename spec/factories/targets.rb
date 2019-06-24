FactoryBot.define do
  factory :target do
    review { nil }
    bean { nil }
    roasted { "MyString" }
    roasted_on { "2019-06-11" }
    grind { "MyString" }
    amount { 1 }
  end
end
