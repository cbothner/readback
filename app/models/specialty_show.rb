class SpecialtyShow < ActiveRecord::Base
  include Show

  include Authority::Abilities
  self.authorizer_name = 'OwnedModelAuthorizer'

  belongs_to :semester
  belongs_to :dj, class_name: "Dj", foreign_key: "coordinator_id"
  has_and_belongs_to_many :djs
  has_many :episodes, as: :show

  alias_attribute :coordinator, :dj

  validates :name, :weekday, presence: true
  validates_time :beginning, :ending

  def rotating_hosts
    (djs + [coordinator]).uniq.sort_by(&:name)
  end

  def default_status
    :unassigned
  end

  def deal
    hosts = rotating_hosts
    # modify only unassigned or unconfirmed episodes
    unconfirmed_episodes = episodes.reject(&:past?).select do |x|
      x.unassigned? || x.normal?
    end
    unconfirmed_episodes.each_with_index do |ep, inx|
      ep.dj = hosts[inx % hosts.count]
      ep.status = :normal
    end

    transaction do 
      unconfirmed_episodes.each(&:save!)
    end
  end
end
