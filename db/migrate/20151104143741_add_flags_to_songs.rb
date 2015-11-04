class AddFlagsToSongs < ActiveRecord::Migration
  def change
    add_column :songs, :local, :boolean
    add_column :songs, :new, :boolean
  end
end
