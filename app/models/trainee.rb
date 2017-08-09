# frozen_string_literal: true

class Trainee < ActiveRecord::Base
  include Person
  include Authority::Abilities
  Acceptance = Struct.new(:timestamp, :dj_id, :message) do
    def accepted?
      !timestamp.nil?
    end

    def accepting_dj
      Dj.find(dj_id).name
    rescue StandardError
      'a training coordinator'
    end
  end
  serialize :demotape, Acceptance
  serialize :broadcasters_exam, Acceptance

  include Person

  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :trackable, :validatable

  include Authority::Abilities

  with_options if: :um_affiliated? do |dj|
    dj.validates :umid, :um_dept, presence: true
    # dj.validates :umid, format: {with: /\A[0-9]{8}\Z/}
  end

  validates :name, :phone, :email, presence: true

  belongs_to :dj, optional: true

  validates :statement, presence: true, unless: :um_affiliated?

  has_many :episodes

  def age
    (Time.zone.now.to_date - created_at.to_date).to_i
  end

  def self.should_email(days_after)
    all.select { |t| t.age >= days_after }
       .select { |t| t.most_recent_email.nil? || t.most_recent_email < days_after }
  end

  def sent_email
    if most_recent_email.to_i == 0
      'Never emailed.'
    else
      "#{most_recent_email.to_i}-day email sent."
    end
  end

  def mark_graduated(approved_by:, associated_dj_instance:)
    self.broadcasters_exam =
      Trainee::Acceptance.new(Time.zone.now, approved_by.id)
    self.dj = associated_dj_instance
    save
  end
end
