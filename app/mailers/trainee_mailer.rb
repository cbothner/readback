class TraineeMailer < ApplicationMailer

  include Resque::Mailer

  default reply_to: "WCBN Training Coordinator <training@wcbn.org>"

  # T + 1.day
  def meeting_minutes(trainee)
    @trainee = trainee
    mail to: @trainee.name_and_email,
      subject: "Welcome to WCBN! Step-by-step to ‘On Air!’"
  end

  # T + 1.week
  def demo_tape_tips(trainee)
    @trainee = trainee
    mail to: @trainee.name_and_email,
      subject: "WCBN Demo Tape Tips"
  end

  # T + 1.month
  def check_in(trainee)
    @trainee = trainee
    mail to: @trainee.name_and_email,
      subject: "How was your first month with WCBN?"
  end

  # T + 3.months
  def reminder(trainee)
    @trainee = trainee
    mail to: @trainee.name_and_email,
      subject: "Three months since you first dropped by WCBN: what’s up?"
  end

end
