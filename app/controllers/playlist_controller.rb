class PlaylistController < ApplicationController
  HOW_FAR_FORWARD = 4.hours
  HOW_FAR_BACK = 6.hours

  def index
    now = Time.zone.now

    @on_air = Episode.on_air

    @past_items = items_between HOW_FAR_BACK.ago, now
    @past_items -= [@on_air]

    @future_episodes = Episode.includes(:dj, :songs, show: [:dj], trainee: [:episodes])
      .where(beginning: now..HOW_FAR_FORWARD.since).order(beginning: :asc)
    if playlist_editor_signed_in?
      @future_items = @future_episodes + SignoffInstance.where(at: now..HOW_FAR_FORWARD.since)
      @future_items.sort_by!(&:at).reverse!
    end

    session[:confirm_episode] = false unless session[:song]
    @song = Song.new(session.delete(:song))
    @song ||= Song.new
    @song.episode ||= @on_air
  end

  def archive
    @from = Time.zone.parse(params[:from]) rescue  HOW_FAR_BACK.ago
    @til = Time.zone.parse(params[:til]) rescue Time.zone.now

    @past_items = items_between @from, @til, ensure_all_songs_have_show_info: request.format == Mime::HTML

    respond_to do |format|
      format.html {render layout: 'wide'}
      format.json
    end
  end

  private

  def items_between(from, til, ensure_all_songs_have_show_info: false)
    songs = Song.includes(:episode).where at: from..til

    episodes = Episode.includes(:dj, show: [:dj]).where ending: from...til
    if ensure_all_songs_have_show_info
      episodes += songs.map(&:episode).reject { |e| episodes.include? e }.uniq
    end

    setbreaks = Setbreak.where at: from..til

    items = songs + episodes + setbreaks

    if playlist_editor_signed_in?
      signoff_instances = SignoffInstance.where(at: from..til)
      items += signoff_instances
    end

    items.sort_by(&:at).reverse

  end

end
