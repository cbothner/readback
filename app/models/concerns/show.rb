# frozen_string_literal: true

# The common interface of FreeformShow, SpecialtyShow, and TalkShow models
module Show
  extend ActiveSupport::Concern
  include Recurring

  included do
    include Authority::Abilities

    belongs_to :semester, touch: true
    has_many :episodes, as: :show, dependent: :destroy

    validates :name, :duration, presence: true
    validates :website, format: { with: /(\Ahttp|\A\Z)/,
                                  message: 'must start with “http://”' }
    validate :show_does_not_conflict_with_any_other

    after_create_commit :propagate_later
    after_update_commit :propagate_if_changed

    self.authorizer_name = 'OwnedModelAuthorizer'
  end

  def show_does_not_conflict_with_any_other
    return nil unless times
    return nil if times.recurrence_rules.empty?
    return nil if times == times_was

    conflicts = (semester.shows - [self])
                .reject { |x| x.times&.recurrence_rules&.empty? }
                .select { |x| times.conflicts_with? x.times }

    return unless conflicts.any?
    conflicting_shows = conflicts.map(&:unambiguous_name).to_sentence
    errors.add(:time, " conflict with #{conflicting_shows}.")
  end

  def propagate_later
    PropagatorJob.perform_later(self)
  end

  def propagate_if_changed
    if saved_change_to_times?
      episodes.reject(&:past?).each(&:destroy)
      propagate_later
    elsif saved_change_to_dj_id?
      episodes.normal.each do |ep|
        ep.update_attributes(dj_id: dj_id)
      end
    end
  end

  def set_times_conditionally_from_params(params)
    return nil if params[:beginning].nil? || params[:duration].nil? || params[:weekday].nil?
    duration = params[:duration].to_f.hours
    bg = Time.zone.parse params[:beginning]
    wd = (params[:weekday].to_i + weekday_offset(bg.hour)) % 7
    unless times && wd == times.first.wday &&
           bg.hour == times.first.hour && bg.min == times.first.min &&
           duration == times.duration
      set_times weekday: wd, hour: bg.hour, minute: bg.min, duration: duration
    end
  end

  def set_times(weekday:, hour:, minute:, duration:, sem: semester)
    self.times = IceCube::Schedule.new(sem.beginning)
    times.duration = duration
    times.add_recurrence_rule(
      IceCube::Rule
      .weekly
      .day(weekday)
      .hour_of_day(hour)
      .minute_of_hour(minute)
      .until(sem.ending)
    )
  end

  def most_recent_episode
    episodes.select { |ep| ep.beginning < Time.zone.now }
            .sort_by(&:beginning).last
  end

  def unambiguous_name
    name
  end

  def time_string(html: true)
    w = "#{%w[Sunday Monday Tuesday Wednesday Thursday Friday
              Saturday][weekday]}s"
    if html
      "<span style=\"display:inline-table\">(#{w},
    #{beginning.strftime('%l:%M')} &ndash; #{ending.strftime('%l:%M%P')})</span>".html_safe
    else
      "(#{w}, #{beginning.strftime '%-l:%M'}–#{ending.strftime '%-l:%M%P'})"
    end
  end

  def seconds_since_six_am
    (beginning - 6.hours).seconds_since_midnight
  end

  def beginning
    return nil unless on_schedule?
    times.first
  end

  def on_schedule?
    !times.nil? && !times.recurrence_rules.empty?
  end

  def ending
    beginning + duration.hours if beginning
  end

  def weekday
    return -1 unless on_schedule?
    (times.first.wday - weekday_offset) % 7
  end

  def duration
    return if times.nil? || times.duration.nil?
    (times.duration / 60.0 / 60.0)
  end

  def website_name
    URI.parse(website || (return nil)).host.sub('www.', '')
  end

  def destroy
    if episodes.select(&:past?).any?
      episodes.reject(&:past?).each(&:destroy)
      update_columns times: nil
      touch
    else
      super
    end
  end

  private

  def weekday_offset(hour = beginning.hour)
    return 1 if (0...6).cover? hour
    0
  end

  def instance_collection_name
    'episodes'
  end

  def instance_params(t)
    { beginning: t, ending: t + duration.hours, status: default_status, dj: dj }
  end

  def includes_instance_at?(t)
    episodes.any? { |ep| ep.beginning == t }
  end
end

class Time
  def hms
    { hour: hour, min: min, sec: sec }
  end
end
