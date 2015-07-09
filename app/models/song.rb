class Song < ActiveRecord::Base
  validates :name, :episode_id, presence: true
  belongs_to :episode
end
