# frozen_string_literal: true

FactoryBot.define do
  factory :episode do
    association :show, factory: :freeform_show
    beginning { Time.zone.now.at_beginning_of_hour }
    ending { beginning + 3.hours }
    dj { show.dj }
  end
end
