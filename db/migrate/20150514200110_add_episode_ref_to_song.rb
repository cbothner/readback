class AddEpisodeRefToSong < ActiveRecord::Migration
  def change
    add_reference :songs, :episode, index: true
    add_foreign_key :songs, :episodes
  end
end
