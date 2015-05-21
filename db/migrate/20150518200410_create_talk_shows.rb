class CreateTalkShows < ActiveRecord::Migration
  def change
    create_table :talk_shows do |t|
      t.references :semester, index: true
      t.references :dj, index: true
      t.string :name
      t.integer :weekday
      t.datetime :beginning
      t.datetime :ending

      t.timestamps null: false
    end
    add_foreign_key :talk_shows, :semesters
    add_foreign_key :talk_shows, :djs
  end
end
