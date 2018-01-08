# frozen_string_literal: true

# When a DJ has other plans during her show’s normal time slot, she needs to
# request a substitute.
class SubRequest < ActiveRecord::Base
  include Authority::Abilities

  enum status: {
    needs_sub: 0,
    needs_sub_in_group: 1,
    needs_sub_including_nighttime_djs: 2,
    confirmed: 3
  }

  serialize :group

  belongs_to :episode

  after_create :send_emails
  after_update :send_emails

  scope :fulfilled, -> { where status: :confirmed }
  scope :unfulfilled, lambda {
    where status: %i[needs_sub needs_sub_in_group
                     needs_sub_including_nighttime_djs]
  }

  def send_emails
    case status.to_sym
    when :needs_sub then SubRequestMailer.request_of_all(self).deliver!
    when :needs_sub_in_group then
      SubRequestMailer.request_of_group(self).deliver!
    when :confirmed
      SubRequestMailer.fulfilled(self, asking_dj: episode.show.dj).deliver!
    end
  end

  def at
    episode.at
  end

  def can_be_fulfilled_by?(user)
    group.include? user.id.to_s
  end

  def requested_djs
    Dj.where id: group
  end

  def for
    "for #{episode.show.name} on #{episode.date_string}"
  end
end
