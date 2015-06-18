require 'rails_helper'

RSpec.describe Show do

  describe "#propagate" do

    before do
      @semester = create(:semester,
                         beginning: Time.zone.parse("January 13, 2015 6:00am"),
                         ending: Time.zone.parse("May 12, 2015 5:59:59am"))
      @show = create(
        :freeform_show, semester: @semester, weekday: 0,
        beginning: Time.zone.parse("Sunday, March 8, 2015 00:00:00"),
        ending: Time.zone.parse("Sunday, March 8, 2015 03:00:00")
      )
    end

    context "when creating a show" do
      before { @show.propagate }

      it "creates the right number of Episodes" do
        expect(@show.episodes.count).to eq @semester.weeks
      end

      it "has Episodes only on the right weekday" do
        weekdays = @show.episodes.map { |x| (x.beginning - 6.hours).wday }.sort.uniq
        expect(weekdays.length).to eq 1
        expect(weekdays).to include @show.weekday
      end

      it "has Episodes beginning at the right times" do
        beginnings = @show.episodes.map do |x|
          x.beginning.hms
        end.sort.uniq
        expect(beginnings).to include @show.beginning.hms
        expect(beginnings.count).to eq 1
      end

      it "has Episodes ending at the right times" do
        endings = @show.episodes.map do |x|
          x.ending.hms
        end.sort.uniq
        expect(endings).to include @show.ending.hms
        expect(endings.count).to eq 1
      end
    end

    context "when editing a show" do
      before :each do
        @show.propagate
        @prev_si = @show.episodes.to_a
        @show.propagate
      end

      it "doesn't change the number of Episodes" do
        expect(@show.episodes.count).to eq @prev_si.count
      end

    end

  end

end
