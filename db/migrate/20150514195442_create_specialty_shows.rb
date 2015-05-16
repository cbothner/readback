class CreateSpecialtyShows < ActiveRecord::Migration
  def change
    create_table :specialty_shows do |t|
      t.references :semester, index: true
      t.string :name
      t.integer :weekday
      t.datetime :beginning
      t.datetime :ending

      t.timestamps null: false
    end
    add_foreign_key :specialty_shows, :semesters
  end
end
