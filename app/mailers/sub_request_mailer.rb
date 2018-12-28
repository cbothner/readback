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

    attach_ical_event

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

    attach_ical_event

    mail to: @dj.name_and_email, subject: "Remember: you’re signed up to sub for #{@episode.show.dj} tomorrow!"
  end

  private

  def attach_ical_event
    attachments['add_to_calendar.ics'] = {
      mime_type: 'text/calendar',
      content: ical_event.to_ical
    }
  end

  def ical_event
    Icalendar::Calendar.new.tap do |cal|
      cal.event do |e|
        e.dtstart = @sub_request.beginning
        e.dtend = @sub_request.ending
        e.summary = @sub_request.show_name
        e.description = "Thanks for subbing for #{@sub_request.show_name}"
        e.location = 'WCBN'
      end
    end
  end
end
