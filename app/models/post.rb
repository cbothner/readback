# frozen_string_literal: true

class Post < ApplicationRecord
  has_many_attached :images

  validates :title, presence: true

  scope :reverse_chronological, -> { order published_at: :desc }
end
