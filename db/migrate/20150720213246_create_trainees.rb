class CreateTrainees < ActiveRecord::Migration
  def change
    create_table :trainees do |t|
      # Demographics
      t.string  :name
      t.string  :phone
      t.string  :email
      t.string  :um_affiliation
      t.string  :um_dept
      t.integer :umid

      # Onboarding Questions
      t.string  :experience
      t.string  :referral
      t.string  :interests
      t.text    :statement

      # Training
      t.string  :demotape
      t.string  :stage2
      t.string  :apprenticeships
      t.string  :broadcasters_exam
      t.integer :most_recent_email

      t.timestamps null: false
    end

    change_table :djs do |t|
      t.remove :experience
      t.remove :referral
      t.remove :interests
      t.remove :statement
      t.remove :stage1
      t.remove :demotape
      t.remove :stage2
      t.remove :apprenticeship_freeform1
      t.remove :apprenticeship_freeform2
      t.remove :apprenticeship_specialty1
      t.remove :apprenticeship_specialty2
      t.remove :broadcasters_exam
      t.remove :most_recent_email
    end

    change_table :episodes do |t|
      t.references :trainee, index: true
    end
  end
end
