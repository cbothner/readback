# frozen_string_literal: true

FactoryBot.define do
  trait :show do
    transient do
      now { Time.zone.now }
      weekday { now.wday }
      hour { now.hour }
      minute 0
      duration 3.hours
    end

    semester
    times do
      IceCube::Schedule
        .new(semester.beginning)
        .tap { |s| s.duration = duration }
        .tap do |s|
          s.add_recurrence_rule IceCube::Rule
            .weekly
            .day(weekday)
            .hour_of_day(hour)
            .minute_of_hour(minute)
            .until(semester.ending)
        end
    end
  end

  factory :freeform_show, traits: [:show] do
    dj
    name 'Freeform'
  end

  factory :specialty_show, traits: [:show] do
    association :coordinator, factory: :dj
    name { ['Radiozilla', 'Dead White Guys', 'What It Is'].sample }

    factory :specialty_show_with_djs do
      transient { dj_count 4 }

      after(:create) do |show, evaluator|
        djs = create_list(:dj, evaluator.dj_count)
        djs.each do |dj|
          show.djs << dj
        end
      end
    end
  end

  factory :talk_show, traits: [:show] do
    dj
    name 'Talk Show'
    topic 'News'
  end
end
