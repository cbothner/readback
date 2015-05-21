class FreeformShow < ActiveRecord::Base
  belongs_to :semester
  belongs_to :dj
  has_many :show_instances, as: :show

  def with(today)
    dj_name = today.dj.nil? ? dj.name : today.dj.name
    "with #{"guest DJ" unless today.dj.nil?} #{dj_name}"
  end
end
