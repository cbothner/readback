class AddProfileDetailsToDj < ActiveRecord::Migration
  def change
    change_table :djs do |t|
      t.string :dj_name
      t.boolean :real_name_is_public
      t.string :public_email
      t.string :website
      t.text :about
      t.text :lists
    end
  end
end
