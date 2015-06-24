class TalkShow < ActiveRecord::Base
  include Show

  belongs_to :semester
  belongs_to :dj
  has_many :episodes, as: :show

  validates :name, :weekday, presence: true
  validates_time :beginning
  validates_time :ending, after: :beginning

  def with(today)
    "a WCBN public affairs show#{" with your host, #{dj.name}" unless dj.nil?}"
  end

  def default_status
    :normal
  end
end
