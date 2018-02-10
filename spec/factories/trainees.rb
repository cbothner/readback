# frozen_string_literal: true

FactoryBot.define do
  trait :trainee do
    name { Faker::Name.name }
    phone { Faker::PhoneNumber.phone_number }
    email { Faker::Internet.email }
    password { Devise.friendly_token }

    um_affiliation 'student'
    um_dept 'LSA Linguistics'
    umid 11_111_111
  end
end
