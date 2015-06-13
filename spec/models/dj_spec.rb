require 'rails_helper'

RSpec.describe Dj, type: :model do

  # UM Affiliation contexts

  #context "when she is affiliated with UM" do
    #subject { create(:dj, um_affiliated: true) }

    #it {should validate_presence_of :umid}
    #it {should validate_numericality_of(:umid).only_integer}
    #it {should validate_length_of(:umid).is_equal_to 8}

    #it {should validate_presence_of :um_dept}


    #it {should be_um_affiliated}

  #end

  #context "when she is not affiliated with UM" do
    #subject { create(:dj, um_affiliated: false) }

    #it {should validate_presence_of :statement}


    #it {should_not be_um_affiliated}

  #end


  # Trainee contexts

  context "when she is a trainee" do
    subject { create( :dj ) }

    it {should_not be_allowed_to_do_daytime_radio }
  end

  context "when she is in her first semester" do
    subject { create( :dj_with_freeform_shows, show_count: 1 ) }

    it "should have a semester count equal to 1" do
      expect(subject.semesters_count).to be 1
    end

    it {should_not be_allowed_to_do_daytime_radio }
  end

  context "when she is a fully trained DJ" do
    subject { create( :dj_with_freeform_shows ) }

    it "should have a semester count greater than 1" do
      expect(subject.semesters_count).to be > 1
    end

    it { should be_allowed_to_do_daytime_radio }
  end

end
