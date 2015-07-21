class FreeformShow < ActiveRecord::Base
  include Show

  include Authority::Abilities
  self.authorizer_name = 'OwnedModelAuthorizer'

  belongs_to :semester
  belongs_to :dj
  has_many :episodes, as: :show

  validates :name, :dj, :weekday, presence: true
  validates_time :beginning, :ending

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
end
