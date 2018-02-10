# frozen_string_literal: true

FactoryBot.define do
  factory :dj do
    name { Faker::Name.name }
    phone { Faker::PhoneNumber.phone_number }
    email { Faker::Internet.email }
    password { Devise.friendly_token }

    um_affiliation 'community' # Default because it requires no UMID, etc.

    trait :student do
      um_affiliation 'student'
      um_dept 'LSA Linguistics'
      umid 11_111_111
    end
  end
end
