module Songs
  class CompletionsController < ApplicationController
    # Get completions based on songs previously entered
    # GET /songs/completions.json
    #   params: { artist: string, name?: string, album?: string }
    def index
      render json: FindCompletions.for(search_params)
    end

    private

    def search_params
      params.permit(:artist, :name, :album)
    end
  end
end
