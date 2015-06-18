class SpecialtyShow < ActiveRecord::Base
  include Show

  belongs_to :semester
  belongs_to :coordinator, class_name: "Dj", foreign_key: "coordinator_id"
  has_and_belongs_to_many :djs
  has_many :episodes, as: :show

  alias_attribute :dj, :coordinator

  def with(today)
    dj_name = today.dj.nil? ? dj.name : today.dj.name
    "with #{"rotating host" unless today.dj.nil?} #{dj_name}"
  end
end
