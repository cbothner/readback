class Setting < ApplicationRecord
  include Authority::Abilities

  def self.get(key)
    value = find_by_key(key).try(:value)
    value == 'false' ? false : value
  end

  def self.find_by_key(key)
    find_by(key: key) || create(key: key)
  end

  def value
    value = super
    value == 'false' ? false : value
  end
end
