# frozen_string_literal: true

class Post < ApplicationRecord
  has_many_attached :images

  validates :title, presence: true
end
