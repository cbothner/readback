class CreateTips < ActiveRecord::Migration[5.0]
  def change
    create_table :tips do |t|
      t.string :uid
      t.string :receipt_data
      t.string :product_id
      t.numeric :value
      t.string :name
      t.string :message

      t.timestamps
    end
  end
end
