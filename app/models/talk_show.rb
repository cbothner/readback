class TalkShow < ActiveRecord::Base
  include Show

  belongs_to :semester
  belongs_to :dj
  has_many :episodes, as: :show

  def with(today)
    "a WCBN public affairs show#{" with your host, #{dj.name}" unless dj.nil?}"
  end
end
