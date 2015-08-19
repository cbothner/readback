class AddRandomToSignoffs < ActiveRecord::Migration
  def change
    add_column :signoffs, :random_interval, :text
    add_column :signoffs, :random, :boolean, default: false
  end
end
