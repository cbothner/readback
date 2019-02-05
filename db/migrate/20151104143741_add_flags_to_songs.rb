class AddFlagsToSongs < ActiveRecord::Migration[5.2]
  def change
    add_column :songs, :local, :boolean
    add_column :songs, :new, :boolean
  end
end
