class AddTopicToTalkShows < ActiveRecord::Migration[5.2]
  def change
    add_column :talk_shows, :topic, :string, null: false, default: ""
  end
end
