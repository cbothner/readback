class AddTimesToShows < ActiveRecord::Migration
  def up
    [:freeform_shows, :specialty_shows, :talk_shows].each do |show_type|
      change_table show_type do |t|
        t.text :times
        t.decimal :duration
      end
      show_type.to_s.classify.constantize.all.each do |show|
        wday = ( show[:weekday] + ( (0...6).include?(show[:beginning].hour) ? 1 : 0) )  % 7
        hour = show[:beginning].hour
        minute = show[:beginning].min
        duration = (show[:ending] - show[:beginning]) / 60 / 60

        times = IceCube::Schedule.new(show.semester.beginning)
        times.add_recurrence_rule(
          IceCube::Rule.weekly
          .day(wday)
          .hour_of_day(hour)
          .minute_of_hour(minute)
          .until(show.semester.ending)
        )
        show.update_columns(times: times)
        show.update_columns(duration: duration)
      end
    end
  end
end
