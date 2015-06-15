require 'rails_helper'

RSpec.describe Show do

  describe "#propagate" do

    context "in the future" do

      before do
        @semester = create(:semester, :future, weeks: 3)
        @show = create(
          :freeform_show, semester: @semester, weekday: 0,
          beginning: Show::UNIMPORTANT_DATE.change(hour: 15, minute: 0),
          ending: Show::UNIMPORTANT_DATE.change(hour: 18, minute: 0)
        )
      end

      context "when creating a show" do
        before { @show.propagate }

        it "creates three ShowInstances" do
          expect(@show.show_instances.count).to eq 3
        end

        it "has ShowInstances only on the right weekday" do
          weekdays = @show.show_instances.map { |x| x.beginning.wday }.sort.uniq
          expect(weekdays.length).to eq 1
          expect(weekdays).to include @show.weekday
        end

        it "has ShowInstances beginning at the right times" do
          beginnings = @show.show_instances.map do |x|
            x.beginning.to_datetime.hms
          end.sort.uniq
          expect(beginnings).to include @show.beginning.hms
          expect(beginnings.count).to eq 1
        end

        it "has ShowInstances ending at the right times" do
          endings = @show.show_instances.map do |x|
            x.ending.to_datetime.hms
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

end
