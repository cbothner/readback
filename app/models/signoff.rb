class Signoff < ActiveRecord::Base
  serialize :times, IceCube::Schedule
  serialize :random_interval

  has_many :signoff_instances

  include Authority::Abilities

  validates :on, presence: true
  validates :times, presence: true, unless: :random
  validates :random_interval, presence: true, if: :random

  before_save do |s|
    if s.random_interval.is_a? ActiveSupport::Duration
      s.random_interval = [s.random_interval.value, s.random_interval.parts]
    end
  end

  after_find do |s|
    if s.random_interval && !s.random_interval.is_a?(ActiveSupport::Duration)
      s.random_interval = ActiveSupport::Duration.new(*s.random_interval)
    end
  end


  def propagate(from = Time.zone.now, til = Semester.maximum(:ending))
    enumerator(from, til).each do |t|
      break if t > til
      signoff_instances.create( on: on, at: t )
    end
  end

  private
  def enumerator(from = Time.zone.now, til = Semester.maximum(:ending))
    if random
      Enumerator.new do |y|
        a, b = from, from + random_interval
        loop do
          y.yield rand(a..b)
          a, b = b, b + random_interval
        end
      end
    else
      times.remaining_occurrences_enumerator(from)
    end
  end

end
