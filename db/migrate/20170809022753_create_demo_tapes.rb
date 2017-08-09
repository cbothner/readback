class CreateDemoTapes < ActiveRecord::Migration[5.0]
  def change
    create_table :demo_tapes do |t|
      t.text :url
      t.text :feedback
      t.timestamp :accepted_at
      t.references :trainee, foreign_key: true

      t.timestamps
    end
  end
end
