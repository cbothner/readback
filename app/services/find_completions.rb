class FindCompletions
  # Get a list of maximum four possible completions for the given search params
  # @param search_params [{ artist: string, name?: string, album?: string }]
  #
  # @return
  # If only a partial artist is provided, return an array of hashes containing
  # only artist names.
  # If an artist and a partial song name is provided, return an array of hashes
  # containing name, album, label, year, and local.
  # If an artist, song name, and a partial album name are provided, return an
  # array of hashes containing album, label, year, and local.
  def self.for(search_params)
    new(search_params).call
  end

  def initialize(params)
    @artist = params[:artist]
    @name = params[:name]
    @album = params[:album]
  end

  def call
    results = find_songs
    transform_to_match_query_case results
  end

  private

  def find_songs
    arrays = candidate_songs
             .group(response_fields)
             .distinct
             .order('count_id desc')
             .limit(4)
             .count(:id)
             .keys
    build_hashes arrays
  end

  def candidate_songs
    songs_with_album_and_label
      .merge(matching_artist_name)
      .merge(maybe_matching_song_name)
      .merge(maybe_matching_album_name)
  end

  def songs_with_album_and_label
    Song.where.not(album: nil, label: nil).where.not(album: '', label: '')
  end

  def matching_artist_name
    Song.where('artist ILIKE ?', prefix(@artist))
  end

  def maybe_matching_song_name
    return Song.all if @name.nil?
    Song.where('name ILIKE ?', prefix(@name))
  end

  def maybe_matching_album_name
    return Song.all if @album.nil?
    Song.where('album ILIKE ?', prefix(@album))
  end

  def prefix(param)
    "#{param}%"
  end

  def build_hashes(arrays)
    arrays.map do |array|
      array = [array] unless array.is_a? Array
      Hash[response_fields.zip(array)]
    end
  end

  def response_fields
    return %w[name album label year local] unless @name.nil?
    return %w[album label year local] unless @album.nil?
    %w[artist]
  end

  def transform_to_match_query_case(results)
    results.map do |result|
      result.transform_values do |val|
        next val unless val.is_a? String
        val.send(query_case)
      end
    end
           .uniq
  end

  # @return [:upcase | :downcase | :hedcase]
  def query_case
    @_query_case ||= @artist.case # Added to String by lib/case_manipulation.rb
  end
end
