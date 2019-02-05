class CreateSetbreaks < ActiveRecord::Migration[5.2]
  def change
    create_table :setbreaks do |t|
      t.datetime :at
      t.index    :at

      t.references  :episode

      t.timestamps null: false
    end
  end
end
