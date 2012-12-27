# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :result do
    position { rand(10) }
    time_msec { (rand(500) + 100) * 1000 }
    participant
  end
end
