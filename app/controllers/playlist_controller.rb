class PlaylistController < ApplicationController
  def index
    response.headers["X-FRAME-OPTIONS"] = "ALLOW-FROM http://wcbn.org"
    iframe = params[:from] == 'iframe'

    songs = Song.includes(:episode).where(at: 6.hours.ago..Time.zone.now)
    episodes = Episode.includes(:dj, show: [:dj]).where("beginning < '#{4.hours.since.utc}' and ending > '#{6.hours.ago.utc}'")
    @on_air = Episode.on_air
    episodes -= [@on_air]
    signoff_instances = SignoffInstance.where(at: 6.hours.ago..4.hours.since)

    items = songs + episodes
    if iframe
      def @on_air.at
        Time.zone.now
      end
      items += [@on_air] 
    end
    items += signoff_instances if dj_signed_in?  # && ON FM COMPUTER

    items.sort_by!(&:at).reverse!
    @past_items = items.select{|i| i.at <= Time.zone.now }
    @future_items = items - @past_items

    session[:confirm_episode] = false unless session[:song]
    @song = Song.new(session.delete(:song))
    @song ||= Song.new
    @song.episode ||= @on_air

    if iframe
      render 'iframe', layout: 'iframe' and return
    end
  end
end
