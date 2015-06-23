class FreeformShow < ActiveRecord::Base
  include Show

  belongs_to :semester
  belongs_to :dj
  has_many :episodes, as: :show

  def with(today)
    today_dj = today.try(:dj)
    dj_name = today_dj.nil? ? dj.name : today_dj.name
    "with #{"guest DJ" unless today_dj.nil?} #{dj_name}"
  end

  def default_status
    :normal
  end
end
