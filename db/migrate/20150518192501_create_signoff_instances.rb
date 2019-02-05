class CreateSignoffInstances < ActiveRecord::Migration[5.2]
  def change
    create_table :signoff_instances do |t|
      t.string :on
      t.string :signed
      t.datetime :at
      t.references :signoff, index: true

      t.timestamps null: false
    end
    add_foreign_key :signoff_instances, :signoffs
  end
end
