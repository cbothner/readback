# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Signing in' do
  context 'as a DJ' do
    let(:dj) { create :dj }

    it 'works' do
      visit root_path
      click_on 'DJ Sign In'

      fill_in 'Email', with: dj.email
      fill_in 'Password', with: dj.password
      click_on 'Log in'

      expect(page).to have_content 'Signed in successfully'
    end

    it 'rejects if the password is incorrect' do
      visit root_path
      click_on 'DJ Sign In'

      fill_in 'Email', with: dj.email
      fill_in 'Password', with: 'wrong password'
      click_on 'Log in'

      expect(page).to have_content 'Invalid Email or Password'
    end
  end
end
