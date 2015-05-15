class CreateSpecialtyJoinTable < ActiveRecord::Migration
  def change
    create_join_table :djs, :specialty_shows do |t|
      # t.index [:dj_id, :specialty_show_id]
      t.index [:specialty_show_id, :dj_id], unique: true
    end
  end
end
