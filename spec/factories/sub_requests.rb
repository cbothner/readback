# frozen_string_literal: true

FactoryBot.define do
  factory :sub_request do
    episode
    status :needs_sub
    reason 'Because!'
    group []
  end
end
