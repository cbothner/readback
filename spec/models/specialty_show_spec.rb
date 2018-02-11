# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SpecialtyShow do
  context 'when dealing episodes out to hosts' do
    it 'should assign djs to all episodes' do
      create_specialty_show

      @specialty_show.deal

      expect(@specialty_show.episodes.where(dj: nil)).to be_empty
    end

    it 'should assign consecutive episodes to different djs' do
      create_specialty_show host_count: 5

      @specialty_show.deal

      episodes = @specialty_show.episodes.first 5
      djs = episodes.map(&:dj).uniq
      expect(djs.count).to eq 5
    end

    it 'should assign djs in the same order for each set of five consecutive episodes' do
      create_specialty_show host_count: 5

      @specialty_show.deal

      djs = @specialty_show.episodes.map(&:dj)
      expect(djs[0..4]).to eq djs[5..9]
    end

    context 'when the coordinator is mistakenly entered as a host' do
      it 'should ignore the duplicate' do
        create_specialty_show host_count: 5
        @specialty_show.djs << @specialty_show.coordinator

        @specialty_show.deal

        djs = @specialty_show.episodes.map(&:dj)
        expect(djs[0..4]).to eq djs[5..9]
      end
    end

    context 'when an episode is assigned already' do
      it 'should skip that episode when dealing' do
        create_specialty_show host_count: 5
        special_episode = @specialty_show.episodes[3]
        assign_episode special_episode, to_dj: @specialty_show.coordinator

        @specialty_show.deal

        expect(special_episode.dj).to eq @specialty_show.coordinator
        djs = [0, 1, 2, 4, 5].map { |x| @specialty_show.episodes[x] }.map(&:dj)
        expect(djs).to eq @specialty_show.hosts
      end
    end
  end

  private

  def create_specialty_show(host_count: 5)
    semester = create :semester, weeks: 16
    @specialty_show = create :specialty_show_with_djs,
                             semester: semester,
                             dj_count: host_count - 1
  end

  def assign_episode(episode, to_dj:)
    episode.dj = to_dj
    episode.status = :confirmed
    episode.save
  end
end
