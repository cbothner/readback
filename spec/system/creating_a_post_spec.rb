# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Creating a post' do
  it 'is possible' do
    visit new_post_path

    fill_in 'Title', with: 'New post'
    fill_in 'Author', with: 'Charles Dickens'
    find('trix-editor[input="post_content"]').click.set 'Hello, world!'

    click_on 'Create Post'

    expect(page).to have_content 'Post successfully created'
  end
end
