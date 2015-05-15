class AddShowInstanceRefToSong < ActiveRecord::Migration
  def change
    add_reference :songs, :show_instance, index: true
    add_foreign_key :songs, :show_instances
  end
end
