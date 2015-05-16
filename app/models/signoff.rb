class Signoff < ActiveRecord::Base
  has_many :signoff_instances
  serialize :times, Array
end
