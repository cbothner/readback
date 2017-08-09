class DemoTape < ApplicationRecord
  include Authority::Abilities

  belongs_to :trainee
end
