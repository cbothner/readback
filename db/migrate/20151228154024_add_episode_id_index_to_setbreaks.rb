class AddEpisodeIdIndexToSetbreaks < ActiveRecord::Migration[5.2]
  def change
    add_index :setbreaks, :episode_id
  end
end
