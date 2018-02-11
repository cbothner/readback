# frozen_string_literal: true

FactoryBot.define do
  factory :setbreak do
    at { Time.zone.now }
  end
end
