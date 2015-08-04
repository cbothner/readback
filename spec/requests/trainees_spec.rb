require 'rails_helper'

RSpec.describe "Trainees", type: :request do
  describe "GET /trainees" do
    it "works! (now write some real specs)" do
      get trainees_path
      expect(response).to have_http_status(200)
    end
  end
end
