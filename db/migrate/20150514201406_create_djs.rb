class CreateDjs < ActiveRecord::Migration
  def change
    create_table :djs do |t|
      t.string :name
      t.string :phone
      t.string :email
      t.string :um_affiliation
      t.text :roles

      t.timestamps null: false
    end
  end
end
