class AddEpisodeIdIndexToSetbreaks < ActiveRecord::Migration
  def change
    add_index :setbreaks, :episode_id
  end
end
