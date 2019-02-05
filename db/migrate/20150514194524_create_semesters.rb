class CreateSemesters < ActiveRecord::Migration[5.2]
  def change
    create_table :semesters do |t|
      t.datetime :beginning
      t.datetime :ending

      t.timestamps null: false
    end
  end
end
