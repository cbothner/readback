class AddShowDescriptionToShows < ActiveRecord::Migration[5.2]
  def change
    add_column :freeform_shows, :description, :text, default: "", null: false
    add_column :specialty_shows, :description, :text, default: "", null: false
    add_column :talk_shows, :description, :text, default: "", null: false
  end
end
