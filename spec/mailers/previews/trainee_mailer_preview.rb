# Preview all emails at http://localhost:3000/rails/mailers/trainee_mailer
class TraineeMailerPreview < ActionMailer::Preview

  # T + 1.day
  def meeting_minutes
    TraineeMailer.meeting_minutes Trainee.first
  end

  # T + 1.week
  def demo_tape_tips
    TraineeMailer.demo_tape_tips Trainee.first
  end

  # T + 1.month
  def check_in
    TraineeMailer.check_in Trainee.first
  end

  # T + 3.months
  def reminder
    TraineeMailer.reminder Trainee.first
  end

end
