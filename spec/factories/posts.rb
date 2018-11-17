# frozen_string_literal: true

FactoryBot.define do
  factory :post do
    title { 'New post' }
    author { 'Charles Dickens' }
    content { 'Hello, world!' }
  end
end
