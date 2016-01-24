class Trainee < ActiveRecord::Base
  Acceptance = Struct.new(:timestamp, :dj_id, :message) do
    def accepted?
      !timestamp.nil?
    end
    def accepting_dj
      Dj.find(dj_id).name rescue "a training coordinator"
    end
  end
  serialize :demotape, Acceptance
  serialize :broadcasters_exam, Acceptance

  include Person

  include Authority::Abilities

  with_options if: :um_affiliated? do |dj|
    dj.validates :umid, :um_dept, presence: true
    #dj.validates :umid, format: {with: /\A[0-9]{8}\Z/}
  end

  validates :name, :phone, :email, presence: true

  belongs_to :dj

  validates :statement, presence: true, unless: :um_affiliated?

  has_many :episodes

  after_commit :schedule_emails, on: [:create]

  def sent_email
    if most_recent_email.to_i == 0
      "Never emailed."
    else
      "#{most_recent_email.to_i}-day email sent."
    end
  end

  def mark_graduated(approved_by:, associated_dj_instance:)
    broadcasters_exam = Trainee::Acceptance.new(Time.zone.now, approved_by.id)
    dj = associated_dj_instance
    save
  end

  def schedule_emails
    TraineeMailer.meeting_minutes(id).deliver_in 1.day
    TraineeMailer.demo_tape_tips(id).deliver_in 1.week
    TraineeMailer.check_in(id).deliver_in 1.month
    TraineeMailer.reminder(id).deliver_in 3.months
  end

end
