# frozen_string_literal: true

FactoryBot.define do
  factory :song do
    episode

    name { Faker::Commerce.product_name }
    artist { Faker::App.name }
    album { Faker::Commerce.department }
    label { Faker::Company.name + ' Records' }
    year { Faker::Number.between 1950, 2015 }
  end
end
