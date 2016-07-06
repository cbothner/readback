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

  desc "Send emails to tomorrow’s subs. This task should run once daily."
  task remind_subs: :environment do
    now = Time.zone.now
    range = (now + 1.day)..(now + 2.days)
    requests = SubRequest.joins(:episode).where episode: { beginning: range }
    requests.each do |request|
      if request.confirmed?
        SubRequestMailer.reminder(request).deliver
      else
        SubRequestMailer.unfulfilled(request).deliver
      end
    end
  end

  desc "Send emails to rotating hosts on the day after tomorrow. Run daily at 5:30AM"
  task remind_rotating_hosts: :environment do
    now = Time.zone.now
    range = (now + 2.days)..(now + 3.days)
    episodes = Episode.where show_type: SpecialtyShow.name, beginning: range
    episodes.each do |episode|
      EpisodeMailer.reminder(episode).deliver if episode.show.hosts.count > 1
    end
  end
end
