class CreateSongs < ActiveRecord::Migration
  def change
    create_table :songs do |t|
      t.string :name
      t.string :artist
      t.string :album
      t.string :label
      t.integer :year
      t.boolean :request
      t.datetime :at

      t.timestamps null: false
    end
  end
end
