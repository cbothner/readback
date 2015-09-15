class Signoff < ActiveRecord::Base
  has_many :signoff_instances

  include Authority::Abilities
  include Recurring

  validates :on, presence: true
  validates :times, presence: true, unless: :random
  validates :random_interval, presence: true, if: :random

  def self.propagate_all(from, til)
    all.each do |s|
      s.propagate from, til
    end
  end


  private
  def enumerator(from = Time.zone.now, til = Semester.maximum(:ending))
    if random
      Enumerator.new do |y|
        a, b = from, from + random_interval.days
        loop do
          y.yield rand(a..b)
          a, b = b, b + random_interval.days
        end
      end
    else
      super
    end
  end

  def instance_params(t)
    {on: on, at: t}
  end

end
