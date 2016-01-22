class TalkShow < ActiveRecord::Base
  include Show

  validates :topic, presence: true 

  belongs_to :dj

  def default_status
    :normal
  end
end
