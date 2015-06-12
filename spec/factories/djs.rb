FactoryGirl.define do

  factory :dj do

    transient do
      trainee false
      nighttime false
    end

    name { Faker::Name.name }
    phone { Faker::PhoneNumber.phone_number }
    email { Faker::Internet.email }

  end

end
