class AddWebsiteToShows < ActiveRecord::Migration[5.2]
  def change
    add_column :freeform_shows, :website, :text
    add_column :specialty_shows, :website, :text
    add_column :talk_shows, :website, :text
  end
end
