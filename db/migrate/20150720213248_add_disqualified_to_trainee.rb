class AddDisqualifiedToTrainee < ActiveRecord::Migration
  def change
    add_column :trainees, :disqualified, :boolean, default: false, null: false
  end
end
