class SubRequestMailer < ApplicationMailer

  include Resque::Mailer

  RADIO_NAMES = %w(radionauts radioteers radiologists radioland radioers
  radioceans radiocopters radiofish radios radioists radiophones radioptics
  radiologizers radiotizers radiosmiths radioramas)

  def request_of_group(sub_request_id)
    @sub_request = SubRequest.find sub_request_id
    @dj = @sub_request.episode.dj

    mail to: @sub_request.requested_djs.map(&:name_and_email),
      subject: "#{@sub_request.episode.dj} asked YOU to sub #{@sub_request.for}!"
  end

  def request_of_all(sub_request_id)
    @sub_request = SubRequest.find sub_request_id
    @dj = @sub_request.episode.dj

    mail to: "Radio Free Ann Arbor <rfaa-mod@umich.edu>",
      subject: "#{@sub_request.episode.dj} needs a sub #{@sub_request.for}!"
  end

  def fulfilled(sub_request_id, asking_dj_id: nil)
    @sub_request = SubRequest.find sub_request_id
    @fulfilling_dj = @sub_request.episode.dj
    @asking_dj = if asking_dj_id.nil?
                   @sub_request.episode.show.dj
                 else
                   Dj.find(asking_dj_id)
                 end

    mail to: @asking_dj.name_and_email,
      cc: @fulfilling_dj.name_and_email,
      subject: "#{@fulfilling_dj} has taken your sub request #{@sub_request.for}"
  end

  def unfulfilled(sub_request_id)
    @sub_request = SubRequest.find sub_request_id
    @dj = @sub_request.episode.dj

    mail to: @dj.name_and_email, subject: "Your sub request for tomorrow is still unclaimed!"
  end

  def reminder(sub_request_id)
    @sub_request = SubRequest.find sub_request_id
    @episode = @sub_request.episode
    @dj = @episode.dj

    mail to: @dj.name_and_email, subject: "Remember: you’re signed up to sub for #{@episode.show.dj} tomorrow!"
  end
end
