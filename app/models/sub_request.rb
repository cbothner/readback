class SubRequest < ActiveRecord::Base
  include Authority::Abilities

  belongs_to :episode
  serialize :group
  enum status: [:needs_sub, :needs_sub_in_group,
                :needs_sub_including_nighttime_djs, :confirmed]

  after_create :send_emails
  after_update :send_emails

  def send_emails
    case status.to_sym
    when :needs_sub then SubRequestMailer.request_of_all(self).deliver!
    when :needs_sub_in_group then SubRequestMailer.request_of_group(self).deliver!
  # when :needs_sub_including_nighttime_djs
      # SubRequestMailer.request_incl_nighttime id
    when :confirmed
      SubRequestMailer.fulfilled(self, asking_dj: episode.show.dj ).deliver!
    end
  end

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
