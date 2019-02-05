class AddRandomToSignoffs < ActiveRecord::Migration[5.2]
  def change
    add_column :signoffs, :random_interval, :text
    add_column :signoffs, :random, :boolean, default: false
  end
end
