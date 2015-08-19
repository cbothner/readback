class Fixnum
  def coerce_into_range(range)
      if range.include? self
        self
      elsif range.min > self
        range.min
      else
        range.max
      end
  end
end

HMSTime = Struct.new(:hour, :minute, :second) do
  include Comparable
  def hour=(new)
    @hour = new.coerce_into_range (0..23)
  end
  def minute=(new)
    @minute = new.coerce_into_range (0..59)
  end
  def second=(new)
    @second = new.coerce_into_range (0..59)
  end
  def <=>(other)
    60*60*hour + 60*minute + second <=> 60*60*other.hour + 60*other.minute + other.second
  end

end


class Times
  attr_accessor :beginning, :ending
  def beginning; @beginning ||= Time.zone.now; end
end

class HashTimes < Times
  attr_accessor :hash
  def hash; @hash ||= Hash.new(); end
  def ending; @ending ||= Semester.all.map(&:ending).max; end

  def each
    return enum_for(:each) unless block_given?

    while beginning < ending do

    end
    #offset = (0..5).include?(beginning.hour) ? 1 : 0
    #wdays = hash.keys.flatten.sort.each.cycle
    #wdays.next until wdays.peek == (beginning - offset.days).wday
    #a = HMSTime(beginning.hour, beginning.minute, beginning.second)
    #wdays.each do |wday|
      #self[wday].each do |hms|
        #if a < hms
          #k
        #end
      #end
    #end
  end

  def [](wday)
    hash.select { |wd| wd.include? wday  }.values.first
  end
end
class RandomTimes < Times
  attr_accessor :frequency
  def frequency; @frequency ||= 1.week; end

  def each
    return enum_for(:each) unless block_given?
    a, b = beginning, beginning+frequency
    loop do
      break if ending && a > ending
      yield rand(a..b)
      a, b = b, b+frequency
    end
  end
end
