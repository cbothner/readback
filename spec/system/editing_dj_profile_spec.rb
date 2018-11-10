# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Editing a DJ profile' do
  let(:dj) { create :dj }

  before(:each) { sign_in dj }

  it 'is possible' do
    visit edit_dj_path dj
    expect(page).to have_content 'Edit Profile'

    attributes = {
      dj_name: 'Cameron',
      name: 'Cameron Bothner',
      real_name_is_public: false,
      phone: '(734) 763-3500',
      email: 'cameronbothner@gmail.com',
      um_affiliation: 'U-M Faculty or Staff',
      umid: 12_345_678,
      um_dept: 'School of Environment and Sustainability',
      website: 'https://cameronbothner.com',
      public_email: 'cameronbothner@gmail.com'
    }

    fill_form_and_submit :dj, :edit, attributes.slice(*profile_attributes)

    expect(page).to have_content 'successfully updated'
    expect(page).to have_content attributes[:name]
  end

  def profile_attributes
    %i[dj_name name dj_real_name_is_public phone email um_affiliation um_dept
       umid website public_email bio picks]
  end
end
