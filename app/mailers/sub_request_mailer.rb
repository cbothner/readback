class SubRequestMailer < ApplicationMailer

  RADIO_NAMES = %w(radionauts radioteers radiologists radioland radioers
  radioceans radiocopters radiofish radios radioists radiophones radioptics
  radiologizers radiotizers radiosmiths radioramas)

  def request_of_group(sub_request)
    @sub_request = sub_request
    @dj = @sub_request.episode.dj

    mail to: @sub_request.requested_djs.map(&:name_and_email),
      subject: "#{@sub_request.episode.dj} asked YOU to sub #{@sub_request.for}!"
  end

  def request_of_all(sub_request)
    @sub_request = sub_request
    @dj = @sub_request.episode.dj

    mail to: "Radio Free Ann Arbor <rfaa-mod@umich.edu>",
      subject: "#{@sub_request.episode.dj} needs a sub #{@sub_request.for}!"
  end

  def fulfilled(sub_request, asking_dj: nil)
    @sub_request = sub_request
    @fulfilling_dj = @sub_request.episode.dj
    @asking_dj = if asking_dj.nil?
                   @sub_request.episode.show.dj
                 else
                   asking_dj
                 end

    cal = ical_event(@sub_request)
    attachments['sub_request_fulfilled.ics'] = {mime_type: 'text/calendar', content: cal.to_ical}

    mail to: @asking_dj.name_and_email,
      cc: @fulfilling_dj.name_and_email,
      subject: "#{@fulfilling_dj} has taken your sub request #{@sub_request.for}"
  end

  def unfulfilled(sub_request)
    @sub_request = sub_request
    @dj = @sub_request.episode.dj

    mail to: @dj.name_and_email, subject: "Your sub request for tomorrow is still unclaimed!"
  end

  def reminder(sub_request)
    @sub_request = sub_request
    @episode = @sub_request.episode
    @dj = @episode.dj

    @duration = @episode.beginning - Time.zone.now

    mail to: @dj.name_and_email, subject: "Remember: you’re signed up to sub for #{@episode.show.dj} tomorrow!"
  end

  private

  def ical_event(sub_request)
    @sub_request = sub_request
    cal = Icalendar::Calendar.new
    cal.event do |e|
      e.dtstart = sub_request.episode.beginning
      e.dtend = sub_request.episode.ending
      e.summary = "Covering #{@sub_request.episode.show.name}"
      e.description = "Thanks for signing up to cover for #{@sub_request.for}"
      e.location = 'WCBN'
      e.ip_class = 'PRIVATE'
      e.organizer = Icalendar::Values::CalAddress.new('mailto:radio@wcbn.org', cn: 'WCBN-FM Ann Arbor')
    end
    cal
  end

end
