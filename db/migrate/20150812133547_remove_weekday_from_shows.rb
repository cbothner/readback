class RemoveWeekdayFromShows < ActiveRecord::Migration
  def change
    [:freeform_shows, :specialty_shows, :talk_shows].each do |show_type|
      change_table show_type do |t|
        t.remove :weekday
      end
    end
  end
end
