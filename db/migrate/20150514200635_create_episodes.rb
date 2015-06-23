class CreateEpisodes < ActiveRecord::Migration
  def change
    create_table :episodes do |t|
      t.references :show, polymorphic: true, index: true
      t.datetime :beginning
      t.datetime :ending

      t.references :dj, index: true
      t.integer :status, default: 0

      t.timestamps null: false
    end
    add_foreign_key :episodes, :djs
  end
end
