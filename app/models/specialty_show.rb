class SpecialtyShow < ActiveRecord::Base
  belongs_to :semester
  has_and_belongs_to_many :djs
  has_many :show_instances, as: :show

  def different_dj_title
    "rotating host"
  end
end
