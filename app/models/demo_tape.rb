# frozen_string_literal: true

class DemoTape < ApplicationRecord
  include Authority::Abilities

  belongs_to :trainee

  has_one_attached :recording

  validates :recording, presence: true

  default_scope -> { order :created_at }
end
