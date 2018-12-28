# frozen_string_literal: true

FactoryBot.define do
  factory :semester do
    transient do
      reference_date Date.tomorrow
      weeks 10
    end

    trait :past do
      reference_date 3.months.ago
    end

    trait :future do
      reference_date 3.months.since
    end

    beginning { reference_date }
    ending { reference_date + weeks.weeks }
  end
end
