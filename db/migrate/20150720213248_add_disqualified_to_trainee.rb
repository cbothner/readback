class AddDisqualifiedToTrainee < ActiveRecord::Migration[5.2]
  def change
    add_column :trainees, :disqualified, :boolean, default: false, null: false
  end
end
