FactoryGirl.define do

  trait :show do

    semester
    weekday { Faker::Number.between 0, 6 }
    beginning { Show::UNIMPORTANT_DATE.change(hour: Faker::Number.between(6, 20)) }
    ending { beginning + Faker::Number.between(1, 3).hours }

    trait :nighttime do
      beginning { Show::UNIMPORTANT_DATE.change hour: [0,3].sample }
      ending { beginning + 3.hours }
    end

  end

  factory :freeform_show, traits: [:show] do
    dj
    name = "Freeform"
  end

  factory :specialty_show, traits: [:show] do
    name { ["Radiozilla", "Dead White Guys", "What It Is"].sample }

    factory :specialty_show_with_djs do
      transient { dj_count 4 }

      after(:create) do |show, evaluator|
        create_list(:dj, evaluator.dj_count, specialty_show: show)
      end

    end
  end

  factory :talk_show, traits: [:show] do
    dj
    name = "Talk Show"
  end

end
