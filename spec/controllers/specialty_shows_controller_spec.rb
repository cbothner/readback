require 'rails_helper'

RSpec.describe SpecialtyShowsController do

  describe "PUT deal" do

    before :each do
      semester = create :semester, weeks: 10
      @show = create :specialty_show_with_djs, semester: semester, dj_count: 4
      @show.propagate
    end

    it "should assign djs to all episodes" do
      patch :deal, id: @show.id
      expect(@show.episodes.reject(&:dj)).to be_empty
    end

    it "should assign five consecutive episodes to five different djs" do
      patch :deal, id: @show.id
      episodes = @show.episodes.first 5
      djs = episodes.map(&:dj).uniq
      expect(djs.count).to eq 5
    end

    it "should assign djs in the same order for each set of five consecutive episodes" do
      patch :deal, id: @show.id
      djs = @show.episodes.map(&:dj)
      expect(djs[0..4]).to eq djs[5..9]
    end

    context "when the coordinator is mistakenly entered as a host" do
      before :each do
        @show.djs << @show.coordinator
      end

      it "should ignore the duplicate" do
        patch :deal, id: @show.id
        djs = @show.episodes.map(&:dj)
        expect(djs[0..4]).to eq djs[5..9]
      end
    end

    context "when an episode is assigned already" do
      before :each do
        @special_episode = @show.episodes[3]
        @special_episode.dj = @show.coordinator
        @special_episode.save
      end

      it "should skip that episode when dealing" do
        patch :deal, id: @show.id
        @show = SpecialtyShow.find(@show.id)

        expect(@special_episode.dj).to eq @show.coordinator
        episodes = [0,1,2,4,5].map { |x| @show.episodes[x] }
        djs = episodes.map(&:dj).map(&:name)
        expect(djs).to eq @show.rotating_hosts.map(&:name)
      end
    end

  end

end
