class Semester < ActiveRecord::Base
  has_many :freeform_shows, dependent: :destroy
  has_many :specialty_shows, dependent: :destroy
  has_many :talk_shows, dependent: :destroy
  validates :beginning, :ending, presence: true
  include Authority::Abilities

  #after_update :propagate_beginning_change, if: :beginning_changed?
  #after_update :propagate_ending_change, if: :ending_changed?

  def self.current
    where("beginning < ?", Time.zone.now).order(beginning: :desc).first || last
  end

  def range
    beginning.to_datetime..ending.to_datetime
  end

  def weeks
    range.count / 7
  end

  def start
    beginning.strftime "%B %-d, %Y"
  end

  def season
    beginning.strftime "%B %Y"
  end

  def end
    ending.strftime "%B %-d, %Y"
  end

  def future?
    Time.zone.now < beginning
  end

  def shows
    freeform_shows.where.not(times: nil) +
      specialty_shows.where.not(times: nil) +
      talk_shows.where.not(times: nil)
  end

  #def fix_beginning_and_ending(from, til)
    #from = from.change(hour: 6, minute: 0, second: 0)
    #til = til.change(hour: 5, minute: 59, second: 59)
    #from, til = til, from if from > til
    #[from, til]
  #end

  #def propagate_shows_between_dates(from, til)
    #byebug
    #from, til = fix_beginning_and_ending from, til
    #from = [from, Time.zone.now].max
    #til = [til, Time.zone.now].max
    #ss = shows
    #ss.each {|x| x.propagate from, til}
  #end

  #def delete_shows_between_dates(from, til)
    #from, til = fix_beginning_and_ending from, til
    #shows.map(&:episodes).flatten.select { |x| x.beginning.between? from, til }
      #.reject(&:past?).each &:destroy
  #end

  #def propagate_beginning_change
    #byebug
    #if beginning_was < beginning  # beginning moved later
      #delete_shows_between_dates beginning_was, beginning
    #elsif beginning < beginning_was  # beginning moved earlier
      #propagate_shows_between_dates beginning, beginning_was
    #end
  #end

  #def propagate_ending_change
    #byebug
    #if ending < ending_was  # ending moved earlier
      #delete_shows_between_dates ending, ending_was
    #elsif ending_was < ending  # ending moved later
      #propagate_shows_between_dates ending, ending_was
    #end
  #end

end
