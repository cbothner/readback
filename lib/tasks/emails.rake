namespace :emails do
  # This constant defines which emails will be sent at which intervals.
  # - The message must be a :symbol that corresponds to one or more templates in 
  #   app/views/trainee_mailer.
  # - The subject will form the subject of the email.
  # - The intervals represent the number of days after their initial sign-up.
  # Sort the intervals longest to smallest to reduce double mailings in case cron fails
  # to run and we have a backlog.
  TRAINEE_EMAILS = [
    {message: :reminder, days_after: 90},
    {message: :check_in, days_after: 30},
    {message: :demo_tape_tips, days_after: 7},
    {message: :meeting_minutes, days_after: 1},
  ]
  desc "Send emails to trainees who need them. This task should be run once daily."
  task remind_trainees: :environment do
    TRAINEE_EMAILS.each do |i|
      Trainee.should_email( i[:days_after] ).each do |t|
        TraineeMailer.send( i[:message], t ).deliver
        t.most_recent_email = i[:days_after]
        t.save
      end
    end
  end

  desc "Send one of each email to training@wcbn.org for testing."
  task test_trainee_reminders: :environment do
    t = Trainee.new
    t.email = "training@wcbn.org"
    t.name = "WCBN Training"
    EMAILS.each do |i|
      TraineeMailer.send( i[:message], t ).deliver
    end
  end
end
