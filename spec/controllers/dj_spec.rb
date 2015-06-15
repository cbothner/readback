require 'rails_helper'

RSpec.describe DjsController do

  describe "GET index" do

    before :all do
      @active_dj = create :dj_with_freeform_shows
      @trained = create :dj
      @trainee = create :dj, active: false
    end

    before :each do
      get :index
    end

    it "assigns @trainees" do 
      expect(assigns(:trainees)).to include @trainee
      expect(assigns(:trainees)).not_to include [@trained, @active_dj]
    end

    it "assigns @active_djs" do
      expect(assigns(:active_djs)).to include @active_dj
      expect(assigns(:active_djs)).not_to include [@trainee, @trained]
    end

    it "assigns @trained" do
      expect(assigns(:trained)).to include @trained
      expect(assigns(:trained)).not_to include [@trainee, @active_dj]
    end

    it { should render_template :index }

  end


  describe "POST create" do

    context "when attributes are valid" do

      before { post :create, dj: FactoryGirl.attributes_for(:dj) }

      it "saves DJ" do
        expect(assigns(:dj)).not_to be_new_record
      end
      
      it { should set_flash }
      it { should redirect_to action: :new }

    end

    context "when attributes are not valid" do

      before { post :create, dj: FactoryGirl.attributes_for(:dj, name: nil) }

      it "does not save DJ" do 
        expect(assigns(:dj)).to be_new_record
      end

      it { should render_template :new }
    end

  end

end
