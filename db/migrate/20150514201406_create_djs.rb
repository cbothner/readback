class CreateDjs < ActiveRecord::Migration[5.2]
  def change
    create_table :djs do |t|
      # Demographics
      t.string  :name
      t.string  :phone
      t.string  :email
      t.string  :um_affiliation
      t.string  :um_dept
      t.string :umid

      # Training
      t.string  :experience
      t.string  :referral
      t.string  :interests
      t.text    :statement
      t.string  :stage1
      t.string  :demotape
      t.string  :stage2
      t.string  :apprenticeship_freeform1
      t.string  :apprenticeship_freeform2
      t.string  :apprenticeship_specialty1
      t.string  :apprenticeship_specialty2
      t.string  :broadcasters_exam
      t.integer  :most_recent_email

      # Trained Station Member
      t.boolean :active

      t.timestamps null: false
    end
  end
end
