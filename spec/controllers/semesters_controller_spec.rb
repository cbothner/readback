# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SemestersController do
  describe 'GET index' do
    before { get :index }
    it { should redirect_to Semester.current }
  end
end
