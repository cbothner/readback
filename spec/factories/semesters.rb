FactoryGirl.define do

  factory :semester do
    transient do
      reference_date Date.today
    end

    trait :past do
      reference_date = 2.months.ago
    end

    trait :future do
      reference_date = 2.months.since
    end

    beginning { reference_date - 2.months }
    ending { reference_date + 2.months }
  end

end
