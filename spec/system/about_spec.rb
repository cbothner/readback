# spec/system/visiting_the_about_page_spec.rb

require 'rails_helper'

RSpec.describe 'Visiting the about page' do
  before do
    create :semester
  end

  it 'has a title' do
    visit about_index_path
    expect(page).to have_content 'About'
  end
end