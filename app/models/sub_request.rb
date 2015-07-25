class SubRequest < ActiveRecord::Base
  include Authority::Abilities

  belongs_to :episode
  serialize :group
  enum status: [:needs_sub, :needs_sub_in_group,
                :needs_sub_including_nighttime_djs, :confirmed]

  def at
    episode.at
  end

  def can_be_fulfilled_by_user(user)
    group.include? user.id
  end

end
