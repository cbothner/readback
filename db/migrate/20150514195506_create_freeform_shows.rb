class CreateFreeformShows < ActiveRecord::Migration[5.2]
  def change
    create_table :freeform_shows do |t|
      t.references :semester, index: true
      t.references :dj, index: true
      t.string :name
      t.integer :weekday
      t.datetime :beginning
      t.datetime :ending

      t.timestamps null: false
    end
    add_foreign_key :freeform_shows, :semesters
    add_foreign_key :freeform_shows, :djs
  end
end
