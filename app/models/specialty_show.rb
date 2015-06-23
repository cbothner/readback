class SpecialtyShow < ActiveRecord::Base
  include Show

  belongs_to :semester
  belongs_to :dj, class_name: "Dj", foreign_key: "coordinator_id"
  has_and_belongs_to_many :djs
  has_many :episodes, as: :show

  alias_attribute :coordinator, :dj

  def with(today)
    dj_name = today.dj.nil? ? dj.name : today.dj.name
    "with #{today.dj.nil? ? "coordinator" : "rotating host"} #{dj_name}"
  end

  def rotating_hosts
    (djs + [coordinator]).uniq.sort_by(&:name)
  end
end
