class SpotifyController < ApplicationController
  CLIENT_ID = "df271c9e066e4f0d8cbf09567e0c5212"
  CLIENT_SECRET = "ff29b735abcd4a24b6e0064dcea769da"
  ENCRYPTION_SECRET = "CWagGmqMumbURuqoWccBKqJoLBihhyUmK2VdDydDKfENUfcNAJ"
  CLIENT_CALLBACK_URL = "wcbn-spotify://callback"
  AUTH_HEADER = "Basic " + Base64.strict_encode64(CLIENT_ID + ":" + CLIENT_SECRET)
  SPOTIFY_ACCOUNTS_ENDPOINT = URI.parse("https://accounts.spotify.com")

  skip_before_filter :verify_authenticity_token

  def swap
    auth_code = params[:code]

    http = Net::HTTP.new(SPOTIFY_ACCOUNTS_ENDPOINT.host, SPOTIFY_ACCOUNTS_ENDPOINT.port)
    http.use_ssl = true

    req = Net::HTTP::Post.new("/api/token")

    req.add_field("Authorization", AUTH_HEADER)

    req.form_data = {
        "grant_type" => "authorization_code",
        "redirect_uri" => CLIENT_CALLBACK_URL,
        "code" => auth_code
    }

    resp = http.request(req)

    # encrypt the refresh token before forwarding to the client
    if resp.code.to_i == 200
        token_data = JSON.parse(resp.body)
        refresh_token = token_data["refresh_token"]
        encrypted_token = refresh_token.encrypt(:symmetric, :password => ENCRYPTION_SECRET)
        token_data["refresh_token"] = encrypted_token
        resp.body = JSON.dump(token_data)
    end

    render json: resp.body
  end

  def refresh
    http = Net::HTTP.new(SPOTIFY_ACCOUNTS_ENDPOINT.host, SPOTIFY_ACCOUNTS_ENDPOINT.port)
    http.use_ssl = true

    req = Net::HTTP::Post.new("/api/token")

    req.add_field("Authorization", AUTH_HEADER)

    encrypted_token = params[:refresh_token]
    refresh_token = encrypted_token.decrypt(:symmetric, :password => ENCRYPTION_SECRET)

    req.form_data = {
        "grant_type" => "refresh_token",
        "refresh_token" => refresh_token
    }

    resp = http.request(req)

    render json: resp.body
  end

end
