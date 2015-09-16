require 'rails_helper'

RSpec.describe "Setbreaks", type: :request do
  describe "GET /setbreaks" do
    it "works! (now write some real specs)" do
      get setbreaks_path
      expect(response).to have_http_status(200)
    end
  end
end
