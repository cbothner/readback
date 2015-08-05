class AddShadowedToEpisode < ActiveRecord::Migration
  def change
    add_column :episodes, :shadowed, :boolean
  end
end
