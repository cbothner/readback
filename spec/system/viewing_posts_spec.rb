# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Viewing posts' do
  it 'is possible' do
    create :post, title: 'Post 1'
    create :post, title: 'Post 2'

    visit posts_path

    expect(page).to have_content 'Post 1'
    expect(page).to have_content 'Post 2'
  end

  it 'shows posts in reverse chronological order of their publish date' do
    create :post, title: 'AAA', published_at: 1.day.ago
    create :post, title: 'BBB', published_at: Time.zone.now

    visit posts_path

    expect('BBB').to appear_before 'AAA'
  end
end
