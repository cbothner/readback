class RemoveDurationFromShows < ActiveRecord::Migration
  def up
    [:freeform_shows, :specialty_shows, :talk_shows].each do |show_type|
      show_type.to_s.classify.constantize.all.each do |show|
        t = show.times
        t.duration = show.duration.hours
        show.update_columns(times: t)
      end

      change_table show_type do |tbl|
        tbl.remove :duration
      end
    end
  end
end
