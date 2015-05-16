class CreateSignoffs < ActiveRecord::Migration
  def change
    create_table :signoffs do |t|
      t.string :on
      t.text :times

      t.timestamps null: false
    end
  end
end
