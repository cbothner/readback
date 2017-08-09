class DemoTape < ApplicationRecord
  include Authority::Abilities

  default_scope -> { order :created_at }

  belongs_to :trainee

  validates :url, presence: true
end
