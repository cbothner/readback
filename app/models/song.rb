class Song < ActiveRecord::Base
  validates :name, presence: true
  belongs_to :show_instance
end
