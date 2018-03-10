# frozen_string_literal: true

class PlaylistsController < ApplicationController
  HOW_FAR_FORWARD = 4.hours
  HOW_FAR_BACK = 6.hours

  before_action :authenticate_playlist_editor!, only: %i[edit]

  with_theme :lime

  def show
    @items = items_between HOW_FAR_BACK.ago, Time.zone.now
    @items.prepend Episode.on_air unless playlist_editor_signed_in?

    return render_edit if playlist_editor_signed_in?
  end

  def archive
    @from = begin
              Time.zone.parse(params[:from])
            rescue StandardError
              HOW_FAR_BACK.ago
            end
    @til = begin
             Time.zone.parse(params[:til])
           rescue StandardError
             Time.zone.now
           end

    @past_items = items_between @from, @til, ensure_all_songs_have_show_info: request.format == Mime[:html]

    respond_to do |format|
      format.html { render layout: 'wide' }
      format.csv do
        headers['Content-Disposition'] = "attachment; filename=\"wcbn-songs-#{@from.strftime '%F'}-#{@til.strftime '%F'}\""
        headers['Content-Type'] ||= 'text/csv'
      end
      format.json
    end
  end

  def search
    @offset = params[:offset].to_i
    @offset ||= 0

    words = begin
              params[:q].split.map { |x| "%#{x}%" }
            rescue StandardError
              ['']
            end

    # The concatenation of all four fields must match all the queries
    songs = Song
            .where((['(artist || name || album || label ILIKE ?)'] * words.size).join(' AND '), *words)
            .includes(episode: [:dj])
            .order(at: :desc)
            .limit(25)
            .offset(25 * @offset)
    episodes = songs.map(&:episode).uniq

    @past_items = (songs + episodes).sort_by(&:at).reverse

    respond_to do |format|
      format.html { render layout: 'headline' }
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

  # We don’t want to expose the /playlist/edit endpoint because we *don’t* want
  # it to be so discoverable. This hijacks the show action and adds the
  # instance variables needed for the new song form, etc.
  def render_edit
    @on_air = Episode.on_air
    set_song

    render :edit, layout: 'redesign'
  end

  def set_song
    @song = Song.new(session.delete(:song))
    @song ||= @on_air.songs.build
  end
end
