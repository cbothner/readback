class AddIndices < ActiveRecord::Migration
  def change
    add_index :songs, :at
    add_index :episodes, :beginning
    add_index :signoff_instances, :at
  end
end
