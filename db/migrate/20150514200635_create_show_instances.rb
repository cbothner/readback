class CreateShowInstances < ActiveRecord::Migration
  def change
    create_table :show_instances do |t|
      t.references :show, polymorphic: true, index: true
      t.references :dj, index: true
      t.datetime :beginning
      t.datetime :ending

      t.timestamps null: false
    end
    add_foreign_key :show_instances, :djs
  end
end
