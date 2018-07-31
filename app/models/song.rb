# frozen_string_literal: true

# We love music
class Song < ActiveRecord::Base
  belongs_to :episode

  attribute :at, :datetime, default: -> { Time.zone.now }

  validates :name, :episode_id, presence: true
  validates_datetime :at,
                     on_or_after: ->(t) { t.episode.beginning },
                     before: -> { Time.zone.now }

  before_validation :strip_spaces
  after_commit { SongBroadcastJob.perform_later self }
  after_create_commit { IcecastUpdateJob.perform_later self }
  after_create_commit { RdsUpdateJob.perform_later self }

  scope :on_air, -> { order(:at).last }

  def as_json(_options = {})
    super(only: %i[id name artist album label year
                   request new local at episode_id])
  end

  private

  def strip_spaces
    %i[name artist album label].each do |attribute|
      send(attribute).strip!
    end
  end
end
