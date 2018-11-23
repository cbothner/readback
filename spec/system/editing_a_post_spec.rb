# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Editing a post' do
  let(:post) { create :post }
  it 'is possible' do
    sign_in create(:dj, :editor)

    visit post_path post
    click_on 'Edit Post'

    fill_in 'Title', with: 'Other title'
    click_on 'Update Post'

    expect(page).to have_content 'Post successfully updated'
  end
end
