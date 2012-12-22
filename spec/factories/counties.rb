FactoryGirl.define do
  factory :county do
    title { Faker::Address.city }
  end
end
