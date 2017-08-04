class Signoff < ActiveRecord::Base
  has_many :signoff_instances

  include Authority::Abilities
  include Recurring

  validates :on, presence: true
  validates :times, presence: true, unless: :random
  validates :random_interval, presence: true, if: :random

  def self.propagate_all(from, til)
    all.each do |s|
      PropagatorJob.perform_later s, from.to_i, til.to_i
    end
  end


  private
  def enumerator(from = Time.zone.now, til = Semester.maximum(:ending))
    if random
      Enumerator.new do |y|
        a, b = from, from + random_interval.days
        loop do
          time = rand(a..b)
          redo unless time.hour.between? 9, 16
          y.yield time
          a, b = b, b + random_interval.days
        end
      end
    else
      super
    end
  end

  def instance_params(t)
    {on: on, at: t, with_cart_name: with_cart_name}
  end

  def includes_instance_at?(t)
    signoff_instances.any? {|s| s.at == t}
  end

end
