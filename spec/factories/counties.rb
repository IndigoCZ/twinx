FactoryGirl.define do
  factory :county do
    title do
      valid_city=nil
      until valid_city
        city=Faker::Address.city
        valid_city=city unless County.find_by_title(city)
      end
      valid_city
    end
  end
end
