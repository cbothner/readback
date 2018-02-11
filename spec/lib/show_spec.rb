# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Show do
  describe '#propagate' do
    before { @show = create :freeform_show }

    context 'when creating a show' do
      it 'creates the right number of Episodes' do
        expect(@show.episodes.count).to eq @show.semester.weeks
      end

      it 'has Episodes only on the right weekday' do
        weekdays = @show.episodes.map { |x| (x.beginning - 6.hours).wday }.sort.uniq
        expect(weekdays.length).to eq 1
        expect(weekdays).to include @show.weekday
      end

      it 'has Episodes beginning at the right times' do
        beginnings = @show.episodes.map do |x|
          x.beginning.hms
        end.sort.uniq
        expect(beginnings).to include @show.beginning.hms
        expect(beginnings.count).to eq 1
      end

      it 'has Episodes ending at the right times' do
        endings = @show.episodes.map do |x|
          x.ending.hms
        end.sort.uniq
        expect(endings).to include @show.ending.hms
        expect(endings.count).to eq 1
      end
    end

    context 'when editing a show' do
      before :each do
        @prev_si = @show.episodes.to_a
        @show.propagate
      end

      it "doesn't change the number of Episodes" do
        expect(@show.episodes.count).to eq @prev_si.count
      end
    end
  end
end
