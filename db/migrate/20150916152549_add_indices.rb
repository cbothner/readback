class AddIndices < ActiveRecord::Migration[5.2]
  def change
    add_index :songs, :at
    add_index :episodes, :beginning
    add_index :signoff_instances, :at
  end
end
