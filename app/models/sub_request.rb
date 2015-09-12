class SubRequest < ActiveRecord::Base
  include Authority::Abilities

  belongs_to :episode
  serialize :group
  enum status: [:needs_sub, :needs_sub_in_group,
                :needs_sub_including_nighttime_djs, :confirmed]

  def at
    episode.at
  end

  def can_be_fulfilled_by?(user)
    group.include? user.id.to_s
  end

  def requested_djs
    group.map { |x| Dj.find x }
  end

  def for
    "for #{episode.show.name} on #{episode.date_string}"
  end

end
