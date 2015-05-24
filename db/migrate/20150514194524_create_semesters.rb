class CreateSemesters < ActiveRecord::Migration
  def change
    create_table :semesters do |t|
      t.datetime :beginning
      t.datetime :ending

      t.timestamps null: false
    end
  end
end
