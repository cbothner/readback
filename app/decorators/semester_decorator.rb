# frozen_string_literal: true

# :nodoc
class SemesterDecorator < Draper::Decorator
  class Cells
    # Defines the default attributes of a schedule cell
    class Base
      attr_reader :css_class, :data_attributes, :rowspan, :show

      def initialize
        @css_class = ''
        @data_attributes = {}
        @rowspan = 1
        @show = nil
      end
    end

    # A schedule cell with no show
    class EmptySlot < Base
      def initialize
        super
        @css_class = 'no-show'
      end
    end

    # A schedule cell with a show
    class Show < Base
      def initialize(show, rowspan)
        @css_class = 'show'
        @data_attributes = { show_type: show.class, show_id: show.id }
        @rowspan = rowspan
        @show = show
      end
    end
  end

  # One row of a schedule table
  class Row
    # @return [Numeric]
    attr_reader :seconds_since_six_am

    # @return [Array<Cell>] Seven cells, ordered Monday through Sunday
    attr_reader :weekdays

    def initialize(seconds_since_six_am, weekdays)
      @seconds_since_six_am = seconds_since_six_am
      @weekdays = weekdays
    end

    def start_time
      time = Time.at(0).midnight + 6.hours + seconds_since_six_am
      time.strftime '%l:%M %P'
    end
  end

  # Schedule organizes a Semester’s Shows into columns by weekday (Monday though
  # Sunday) and rows by time of day (6am-6am). Cells have defined rowskips to
  # align start and end times across weekdays
  class Schedule
    # @return [Array<Row>]
    attr_reader :rows

    def initialize(semester)
      @rowskip_countdown = Hash.new 0
      @rows = build_rows(semester.shows)
    end

    private

    def build_rows(shows)
      @shows_by_start = shows.group_by(&:seconds_since_six_am)
      @start_times = @shows_by_start.keys.sort
      @start_times.map { |time| build_row time }
    end

    def build_row(time)
      weekdays = 1.upto(7).map { |weekday| get_cell(weekday, time) }
      Row.new(time, weekdays)
    end

    def get_cell(weekday, time)
      if @rowskip_countdown[weekday].positive?
        @rowskip_countdown[weekday] -= 1
        return
      end

      get_cell!(weekday, time).tap do |c|
        @rowskip_countdown[weekday] = c.rowspan - 1
      end
    end

    def get_cell!(weekday, time)
      show = @shows_by_start[time].find { |s| s.weekday == weekday % 7 }
      return Cells::EmptySlot.new if show.nil?

      Cells::Show.new(show, get_rowspan(show))
    end

    def get_rowspan(show)
      from = show.seconds_since_six_am
      til = from + show.duration.hours.to_i
      @start_times.grep(from...til).count
    end
  end

  delegate_all

  def schedule
    Schedule.new(self)
  end

  def start
    beginning.strftime '%B %-d, %Y'
  end

  def season
    beginning.strftime '%B %Y'
  end

  def end
    ending.strftime '%B %-d, %Y'
  end

  def range
    self.start + '-' + self.end
  end
end
