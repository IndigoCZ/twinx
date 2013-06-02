FactoryGirl.define do
  factory :team do
    title do
      valid_city=nil
      until valid_city
        city=Faker::Address.city
        valid_city=city unless Team.find_by_title(city)
      end
      valid_city
    end
    race
  end
end
