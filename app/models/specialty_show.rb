class SpecialtyShow < ActiveRecord::Base
  include Show

  belongs_to :semester
  has_and_belongs_to_many :djs
  has_many :show_instances, as: :show

  def with(today)
    dj_name = today.dj.nil? ? dj.name : today.dj.name
    "with #{"rotating host" unless today.dj.nil?} #{dj_name}"
  end
end
