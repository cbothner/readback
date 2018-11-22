# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AlbumArtworksController, type: :controller do
  describe 'GET #show' do
    context 'when able to find album art' do
      it 'redirects to the artwork' do
        allow(AlbumArt).to receive(:for_song).and_return 'artwork url'
        song = create :song

        get :show, params: { song_id: song.id }

        expect(response).to redirect_to 'artwork url'
      end
    end

    context 'when unable to find album art' do
      it 'redirects to the artwork' do
        allow(AlbumArt).to receive(:for_song).and_return nil
        song = create :song

        get :show, params: { song_id: song.id }

        expect(response).to have_http_status :not_found
      end
    end
  end
end
