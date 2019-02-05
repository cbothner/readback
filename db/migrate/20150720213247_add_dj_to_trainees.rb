class AddDjToTrainees < ActiveRecord::Migration[5.2]
  def change
    add_reference :trainees, :dj, index: true
    add_foreign_key :trainees, :djs
  end
end
