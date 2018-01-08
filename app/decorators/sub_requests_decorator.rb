# frozen_string_literal: true

# @see SubRequest
class SubRequestsDecorator < Draper::CollectionDecorator
  # A single day’s worth of sub requests. Implements methods to present a cell.
  class Day
    attr_reader :requests

    delegate :past?, to: :@date

    def initialize(date, requests)
      @date = date
      @requests = requests
    end

    def html_class
      'active' unless past?
    end

    def to_s
      fmt = @date.day == 1 || @date == Time.zone.today ? '%b %d' : '%d'
      @date.strftime fmt
    end
  end

  # Iterate through sub requests in groups of one week at a time
  # @yield [Enumerator<Enumerator<SubRequest>>] 7 days of sub requests at a time
  def each_week(&block)
    each_day.each_slice 7, &block
  end

  # Iterates through days of sub requests
  # @yield [Enumerator<SubRequests>]
  def each_day(&block)
    last_day = requests_by_day.keys.max
    (Time.zone.today.monday..last_day).map do |day|
      requests = requests_by_day[day] || []
      Day.new(day, requests.sort_by(&:at))
    end.each(&block)
  end

  private

  def requests_by_day
    @_requests_by_day = decorated_collection.group_by do |request|
      request.at.midnight.to_date
    end
  end
end
