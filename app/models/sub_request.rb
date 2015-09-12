class SubRequest < ActiveRecord::Base
  include Authority::Abilities

  belongs_to :episode
  serialize :group
  enum status: [:needs_sub, :needs_sub_in_group,
                :needs_sub_including_nighttime_djs, :confirmed]

  after_create :send_emails, :schedule_unfulfilled_email
  after_update :send_emails, :schedule_reminder_email
  before_destroy :unschedule_emails

  def send_emails
    case status.to_sym
    when :needs_sub then SubRequestMailer.request_of_all(id).deliver
    when :needs_sub_in_group then SubRequestMailer.request_of_group(id).deliver
  # when :needs_sub_including_nighttime_djs
      # SubRequestMailer.request_incl_nighttime id
    when :confirmed 
      SubRequestMailer.fulfilled(id, asking_dj_id: episode.dj_id_was).deliver
    end
  end

  def schedule_unfulfilled_email
    SubRequestMailer.unfulfilled(id).deliver_at(episode.reminder_email_time)
  end

  def schedule_reminder_email
    unschedule_email
    SubRequestMailer.reminder(id).deliver_at(episode.reminder_email_time)
  end

  def unschedule_email
    SubRequestMailer.unfulfilled(id).unschedule_delivery
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
