class CreateSubRequests < ActiveRecord::Migration
  def change
    create_table :sub_requests do |t|
      t.references :episode, index: true
      t.integer :status
      t.string :reason
      t.string :group

      t.timestamps null: false
    end
    add_foreign_key :sub_requests, :episodes
  end
end
