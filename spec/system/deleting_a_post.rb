# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Deleting a post' do
  it 'is possible' do
    sign_in create(:dj, :editor)

    post = create :post, title: 'Hello, world!'
    visit post_path post

    accept_confirm 'Are you sure?' do
      click_on 'Delete Post'
    end

    expect(page).to have_content 'Post successfully deleted'
    expect(page).not_to have_content 'Hello, world!'
  end
end
