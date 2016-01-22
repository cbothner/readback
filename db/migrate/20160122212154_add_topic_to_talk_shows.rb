class AddTopicToTalkShows < ActiveRecord::Migration
  def change
    add_column :talk_shows, :topic, :string, null: false, default: ""
  end
end
