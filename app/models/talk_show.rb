class TalkShow < ActiveRecord::Base
  include Show

  include Authority::Abilities
  self.authorizer_name = 'OwnedModelAuthorizer'

  belongs_to :semester
  belongs_to :dj
  has_many :episodes, as: :show

  validates :name, :weekday, presence: true
  validates_time :beginning
  validates_time :ending, after: :beginning

  def default_status
    :normal
  end
end
