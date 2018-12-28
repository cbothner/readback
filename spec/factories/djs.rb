# frozen_string_literal: true

FactoryBot.define do
  factory :dj do
    name { Faker::Name.name }
    phone { Faker::PhoneNumber.phone_number }
    email { Faker::Internet.email }
    password { Devise.friendly_token }

    um_affiliation 'community' # Default because it requires no UMID, etc.

    trait :grandfathered_in do
      after :create do |dj|
        dj.add_role :grandfathered_in
      end
    end

    trait :student do
      um_affiliation 'student'
      um_dept 'LSA Linguistics'
      umid 11_111_111
    end

    trait :superuser do
      after :create do |dj|
        dj.add_role :superuser
      end
    end

    %w[freeform_show specialty_show talk_show].each do |s|
      factory "dj_with_#{s}s".to_sym do
        transient { show_count 2 }
        after(:create) do |dj, evaluator|
          create_list s.to_sym, evaluator.show_count, dj: dj
        end
      end
    end
  end
end
