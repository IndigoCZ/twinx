FactoryGirl.define do
  factory :constraint do
    restrict "gender"
    string_value "male"
    category
  end
end
