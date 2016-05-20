class Song < ActiveRecord::Base
  validates :name, :episode_id, presence: true
  validates_datetime :at,
    on_or_after: ->(t){ t.episode.beginning },
    before: ->(t){ Time.zone.now }

  belongs_to :episode

  after_create :post_information_to_icecast

  def post_information_to_icecast
    %w(hd mid hi)
      .each do |qual|
      Kernel.system "curl --max-time 0.5 --user admin:#{ENV['ICECAST_ADMIN_PASSWORD']}  \"http://floyd.wcbn.org:8000/admin/metadata?mount=/wcbn-#{qual}.mp3&mode=updinfo&song=#{Rack::Utils.escape metadata_string}\""
    end
  end

  def metadata_string
    "WCBN-FM: “#{name}”#{" by #{artist}" unless artist.blank?} – on #{episode.show.name} with #{episode.dj}"
  end
end
