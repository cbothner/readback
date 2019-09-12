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

  before_create :ensure_group_is_not_sparse
  before_create :set_status_from_request_group
  after_save :send_emails
  after_save :update_episode_status
  after_destroy :reset_episode_status

  scope :fulfilled, -> { where status: :confirmed }
  scope :unfulfilled, lambda {
    where status: %i[needs_sub needs_sub_in_group
                     needs_sub_including_nighttime_djs]
  }

  delegate :beginning, :ending, :show, to: :episode

  def send_emails
    case status.to_sym
    when :needs_sub then
      SubRequestMailer.request_of_all(self).deliver_later
    when :needs_sub_in_group then
      SubRequestMailer.request_of_group(self).deliver_later
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

  def show_name
    show.unambiguous_name
  end

  private

  def ensure_group_is_not_sparse
    group.reject!(&:blank?)
  end

  def set_status_from_request_group
    self.status = group.empty? ? :needs_sub : :needs_sub_in_group
  end

  def update_episode_status
    episode.update status: status
  end

  def reset_episode_status
    episode.update status: :confirmed
  end
end
