class FreeformShow < ActiveRecord::Base
  include Show

  belongs_to :semester
  belongs_to :dj
  has_many :episodes, as: :show

  def with(today)
    today_dj = today.nil? ? today : today.dj
    dj_name = today_dj.nil? ? dj.name : today_dj.name
    "with #{"guest DJ" unless today_dj.nil?} #{dj_name}"
  end
end
