# frozen_string_literal: true

class MigrationTrainee < ActiveRecord::Base
  self.table_name = :trainees
end

class AddDeviseToTrainees < ActiveRecord::Migration[5.0]
  def change
    reversible do |dir|
      dir.up do
        delete_duplicate_trainees
      end
    end

    change_table :trainees do |t|
      ## Database authenticatable
      t.string :encrypted_password, null: false, default: ''

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.inet     :current_sign_in_ip
      t.inet     :last_sign_in_ip

      ## Confirmable
      # t.string   :confirmation_token
      # t.datetime :confirmed_at
      # t.datetime :confirmation_sent_at
      # t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      # t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at

      # Uncomment below if timestamps were not included in your original model.
      # t.timestamps null: false
    end

    change_column_null :trainees, :email, false
    change_column_default :trainees, :email, from: nil, to: ''

    add_index :trainees, :email,                unique: true
    add_index :trainees, :reset_password_token, unique: true
    # add_index :trainees, :confirmation_token,   unique: true
    # add_index :trainees, :unlock_token,         unique: true
  end

  private

  def delete_duplicate_trainees
    say 'deleting duplicate trainees'
    trainees_to_delete.each(&:destroy)
  end

  def trainees_to_delete
    non_unique_trainees
      .order(created_at: :asc)
      .group_by(&:email)
      .values
      .flat_map { |ts| ts[1..-1] }
  end

  def non_unique_trainees
    Trainee.where email: duplicate_emails
  end

  def duplicate_emails
    Trainee.group(:email).having('count(*) > 1').pluck(:email)
  end
end
