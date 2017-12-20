class Song < ActiveRecord::Base
  belongs_to :episode

  validates :name, :episode_id, presence: true
  validates_datetime :at,
                     on_or_after: ->(t) { t.episode.beginning },
                     before: ->(_t) { Time.zone.now }

  after_commit { SongBroadcastJob.perform_later self }
  after_create_commit :post_information_to_icecast

  scope :on_air, ->() { order(:at).last }

  def as_json(_options = {})
    super(only: %i[id name artist album label year request new local at])
  end

  def post_information_to_icecast
    return unless ENV['ICECAST_ADMIN_PASSWORD']
    %w[hd mid hi]
      .each do |qual|
      Kernel.system "curl --max-time 0.5 --user admin:#{ENV['ICECAST_ADMIN_PASSWORD']}  \"http://floyd.wcbn.org:8000/admin/metadata?mount=/wcbn-#{qual}.mp3&mode=updinfo&song=#{Rack::Utils.escape metadata_string}\""
    end
  end

  def metadata_string
    "WCBN-FM: “#{name}”#{" by #{artist}" unless artist.blank?} – on #{episode.show.name} with #{episode.dj}"
  end
end
