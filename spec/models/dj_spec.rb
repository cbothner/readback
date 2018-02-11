# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Dj, type: :model do
  before :example do
    @dj = Dj.new(
      name: 'Cameron Bothner',
      phone: '(734) 395-5779',
      email: 'cbothner@umich.edu'
    )
  end

  subject { @dj }

  it { should validate_presence_of :name }
  it { should validate_presence_of :phone }
  it { should validate_presence_of :email }

  ###########################
  # UM Affiliation contexts #
  ###########################

  context 'when she is affiliated with UM' do
    subject do
      @dj.um_affiliation = 'student'
      @dj
    end

    it {
      should validate_presence_of(:umid).with_message(
        'can’t be blank when U-M Affiliation is not Community Member'
      )
    }

    it {
      should validate_presence_of(:um_dept)
        .with_message 'can’t be blank when U-M Affiliation is not Community Member'
    }

    it { should be_um_affiliated }
  end

  context 'when she is not affiliated with UM' do
    subject do
      @dj.um_affiliation = 'community'
      @dj
    end

    it { should_not be_um_affiliated }
  end

  ####################
  # Trainee contexts #
  ####################

  context 'when she is a trainee' do
    subject { create(:dj) }

    it { should_not be_allowed_to_do_daytime_radio }
  end

  context 'when she is in her first semester' do
    subject { create(:dj_with_freeform_shows, show_count: 1) }

    it 'should have a semester count equal to 1' do
      expect(subject.semesters_count).to be 1
    end

    it { should_not be_allowed_to_do_daytime_radio }
  end

  context 'when she is a fully trained DJ' do
    subject { create(:dj_with_freeform_shows) }

    it 'should have a semester count greater than 1' do
      expect(subject.semesters_count).to be > 1
    end

    it { should be_allowed_to_do_daytime_radio }
  end
end
