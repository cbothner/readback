FactoryGirl.define do

  factory :dj do

    transient do
      trainee false
      nighttime false
      um_affiliated true
    end

    name { Faker::Name.name }
    phone { Faker::PhoneNumber.phone_number }
    email { Faker::Internet.email }
    um_affiliation {
      um_affiliated ? Dj::AFFILIATED_UM_AFFILIATIONS.sample : Dj::UNAFFILIATED_UM_AFFILIATIONS
    }
    um_dept { ["LSA Linguistics", "LSA Physics", "COE Computer Science"]
      .sample if um_affiliated }
    umid { Faker::Number.between(1111_1111, 9999_9999) if um_affiliated }
    statement { Faker::Lorem.paragraph unless um_affiliated }

  end

end
