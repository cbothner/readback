class TalkShow < ActiveRecord::Base
  include Show

  belongs_to :dj

  def default_status
    :normal
  end
end
