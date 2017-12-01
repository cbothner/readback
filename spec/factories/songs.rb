FactoryBot.define do

  factory :song do
    name { Faker::Commerce.product_name }
    artist { Faker::App.name }
    album { Faker::Commerce.department }
    label { Faker::Company.name + " Records" }
    year { Faker::Number.between 1950, 2015 }
    request { [true, false].sample }
  end

end
