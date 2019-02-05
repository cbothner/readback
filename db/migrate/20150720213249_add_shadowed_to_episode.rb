class AddShadowedToEpisode < ActiveRecord::Migration[5.2]
  def change
    add_column :episodes, :shadowed, :boolean
  end
end
