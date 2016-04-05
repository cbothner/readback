class FreeformShow < ActiveRecord::Base
  include Show

  belongs_to :dj
  validates :dj, presence: true

  def default_status
    :normal
  end

  def unambiguous_name
    if name == "Freeform"
      "Freeform w/ #{dj}"
    else
      name
    end
  end

  def alternate_host_name
    "guest DJ"
  end

  def with
    "with #{dj}"
  end

  def djs
    [dj]
  end
end
