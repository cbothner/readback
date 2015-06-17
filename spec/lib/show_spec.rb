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

      it "creates the right number of ShowInstances" do
        expect(@show.show_instances.count).to eq @semester.weeks
      end

      it "has ShowInstances only on the right weekday" do
        weekdays = @show.show_instances.map { |x| x.beginning.wday }.sort.uniq
        expect(weekdays.length).to eq 1
        expect(weekdays).to include @show.weekday
      end

      it "has ShowInstances beginning at the right times" do
        beginnings = @show.show_instances.map do |x|
          x.beginning.hms
        end.sort.uniq
        expect(beginnings).to include @show.beginning.hms
        expect(beginnings.count).to eq 1
      end

      it "has ShowInstances ending at the right times" do
        endings = @show.show_instances.map do |x|
          x.ending.hms
        end.sort.uniq
        expect(endings).to include @show.ending.hms
        expect(endings.count).to eq 1
      end
    end

    context "when editing a show" do
      before :each do
        @show.propagate
        @prev_si = @show.show_instances.to_a
        @show.propagate
      end

      it "doesn't change the number of ShowInstances" do
        expect(@show.show_instances.count).to eq @prev_si.count
      end

    end

  end

end
