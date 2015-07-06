class FreeformShow < ActiveRecord::Base
  include Show

  belongs_to :semester
  belongs_to :dj
  has_many :episodes, as: :show

  validates :name, :dj, :weekday, presence: true
  validates_time :beginning
  validates_time :ending, after: :beginning

  # TODO: refactor this out of here.
  def with(today)
    today_dj = today.try(:dj)
    dj_name = today_dj.nil? ? dj.name : today_dj.name
    "with #{"guest DJ" unless today_dj.nil?} #{dj_name}"
  end

  def default_status
    :normal
  end
end
