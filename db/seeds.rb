trainees = YAML.load_file 'db/private/trainees.yml'
Dj.create trainees
Dj.all.each do |dj| dj.update_attributes(active: !dj.broadcasters_exam.blank?) end
roster = YAML.load_file 'db/private/roster.yml'
roster.reject! {|dj| Dj.find_by_name(dj["name"])}
djs_in_roster = Dj.create roster
djs_in_roster.each do |dj| dj.update_attributes active: true end

cameron = Dj.find_by_name "Cameron Bothner"
brandok = Dj.find_by_name "Brandon Kierdorf"
tyler = Dj.find_by_name "Tyler Carr"
dwb = Dj.find_by_name "David Bothner"
oldsem = Semester.create( beginning: "Tue 13 January 2015 06:00:00 Eastern Time (US & Canada)", ending: "Tue, 12 May 2015 6:00:00 Eastern Time (US & Canada)"  )
shows = []
shows.append oldsem.freeform_shows.create({name: "Radio Rama Lama Fa Fa Fa -or- Booze, Broads, Boards and Rods", weekday: 1, beginning: "1972-01-23 22:00:00 Eastern Time (US & Canada)", ending: "1972-01-23 23:59:59 Eastern Time (US & Canada)"})
shows.append oldsem.freeform_shows.create({name: "The Daily Sports Report", weekday: 1, beginning: "1972-01-23 18:00:00 Eastern Time (US & Canada)", ending: "1972-01-23 18:30:00 Eastern Time (US & Canada)"})
shows.append oldsem.freeform_shows.create({name: "The Daily Sports Report", weekday: 2, beginning: "1972-01-23 18:00:00 Eastern Time (US & Canada)", ending: "1972-01-23 18:30:00 Eastern Time (US & Canada)"})
shows.append oldsem.freeform_shows.create({name: "The Daily Sports Report", weekday: 3, beginning: "1972-01-23 18:00:00 Eastern Time (US & Canada)", ending: "1972-01-23 18:30:00 Eastern Time (US & Canada)"})
shows.append oldsem.freeform_shows.create({name: "The Daily Sports Report", weekday: 4, beginning: "1972-01-23 18:00:00 Eastern Time (US & Canada)", ending: "1972-01-23 18:30:00 Eastern Time (US & Canada)"})
shows.append oldsem.freeform_shows.create({name: "SlipStream Radio", weekday: 1, beginning: "1972-01-23 06:00:00 Eastern Time (US & Canada)", ending: "1972-01-23 09:00:00 Eastern Time (US & Canada)"})
shows.append oldsem.freeform_shows.create({name: "Area of Refuge", weekday: 1, beginning: "1972-01-23 09:00:00 Eastern Time (US & Canada)", ending: "1972-01-23 12:00:00 Eastern Time (US & Canada)"})
shows.append oldsem.freeform_shows.create({name: "Bleached Meat", weekday: 1, beginning: "1972-01-23 12:00:00 Eastern Time (US & Canada)", ending: "1972-01-23 15:00:00 Eastern Time (US & Canada)"})
shows.append oldsem.freeform_shows.create({name: "Freeform", weekday: 1, beginning: "1972-01-23 15:00:00 Eastern Time (US & Canada)", ending: "1972-01-23 17:00:00 Eastern Time (US & Canada)"})
shows.append oldsem.freeform_shows.create({name: "Disco Drive", weekday: 1, beginning: "1972-01-23 17:00:00 Eastern Time (US & Canada)", ending: "1972-01-23 18:00:00 Eastern Time (US & Canada)"})
shows.append oldsem.freeform_shows.create({name: "Grey Matters", weekday: 1, beginning: "1972-01-23 18:30:00 Eastern Time (US & Canada)", ending: "1972-01-23 19:00:00 Eastern Time (US & Canada)"})
shows.append oldsem.freeform_shows.create({name: "Yazoo City Calling", weekday: 1, beginning: "1972-01-23 19:00:00 Eastern Time (US & Canada)", ending: "1972-01-23 20:00:00 Eastern Time (US & Canada)"})
shows.append oldsem.freeform_shows.create({name: "Groovasaurus", weekday: 1, beginning: "1972-01-23 20:00:00 Eastern Time (US & Canada)", ending: "1972-01-23 22:00:00 Eastern Time (US & Canada)"})
shows.append oldsem.freeform_shows.create({name: "Freeform", weekday: 1, beginning: "1972-01-23 00:00:00 Eastern Time (US & Canada)", ending: "1972-01-23 03:00:00 Eastern Time (US & Canada)"})
shows.append oldsem.freeform_shows.create({name: "Trying Not To Swear", weekday: 1, beginning: "1972-01-23 03:00:00 Eastern Time (US & Canada)", ending: "1972-01-23 06:00:00 Eastern Time (US & Canada)"})
shows.append oldsem.freeform_shows.create({name: "Freeform", weekday: 2, beginning: "1972-01-23 00:00:00 Eastern Time (US & Canada)", ending: "1972-01-23 03:00:00 Eastern Time (US & Canada)"})
shows.append oldsem.freeform_shows.create({name: "Freeform", weekday: 2, beginning: "1972-01-23 03:00:00 Eastern Time (US & Canada)", ending: "1972-01-23 06:00:00 Eastern Time (US & Canada)"})
shows.append oldsem.freeform_shows.create({name: "Dr. Awesome's Cabinet of Wonders - and - Trans Radio", weekday: 2, beginning: "1972-01-23 06:00:00 Eastern Time (US & Canada)", ending: "1972-01-23 09:00:00 Eastern Time (US & Canada)"})
shows.append oldsem.freeform_shows.create({name: "Freeform", weekday: 2, beginning: "1972-01-23 09:00:00 Eastern Time (US & Canada)", ending: "1972-01-23 12:00:00 Eastern Time (US & Canada)"})
shows.append oldsem.freeform_shows.create({name: "Flashback to the Future", weekday: 2, beginning: "1972-01-23 12:00:00 Eastern Time (US & Canada)", ending: "1972-01-23 15:00:00 Eastern Time (US & Canada)"})
shows.append oldsem.freeform_shows.create({name: "Freeform", weekday: 2, beginning: "1972-01-23 15:00:00 Eastern Time (US & Canada)", ending: "1972-01-23 17:00:00 Eastern Time (US & Canada)"})
shows.append oldsem.freeform_shows.create({name: "Freeform with Zach", weekday: 2, beginning: "1972-01-23 17:00:00 Eastern Time (US & Canada)", ending: "1972-01-23 18:00:00 Eastern Time (US & Canada)"})
shows.append oldsem.freeform_shows.create({name: "IT", weekday: 2, beginning: "1972-01-23 18:30:00 Eastern Time (US & Canada)", ending: "1972-01-23 19:00:00 Eastern Time (US & Canada)"})
shows.append oldsem.freeform_shows.create({name: "Train to Skaville", weekday: 2, beginning: "1972-01-23 19:00:00 Eastern Time (US & Canada)", ending: "1972-01-23 20:00:00 Eastern Time (US & Canada)"})
shows.append oldsem.freeform_shows.create({name: "Go Kat Go", weekday: 2, beginning: "1972-01-23 20:00:00 Eastern Time (US & Canada)", ending: "1972-01-23 22:00:00 Eastern Time (US & Canada)"})
shows.append oldsem.freeform_shows.create({name: "Freeform", weekday: 3, beginning: "1972-01-23 00:00:00 Eastern Time (US & Canada)", ending: "1972-01-23 03:00:00 Eastern Time (US & Canada)"})
shows.append oldsem.freeform_shows.create({name: "Freeform", weekday: 3, beginning: "1972-01-23 03:00:00 Eastern Time (US & Canada)", ending: "1972-01-23 06:00:00 Eastern Time (US & Canada)"})
shows.append oldsem.freeform_shows.create({name: "Chicken Soup for the Vegetarian Soul", weekday: 3, beginning: "1972-01-23 06:00:00 Eastern Time (US & Canada)", ending: "1972-01-23 09:00:00 Eastern Time (US & Canada)"})
shows.append oldsem.freeform_shows.create({name: "Stayin' Alive", weekday: 3, beginning: "1972-01-23 09:00:00 Eastern Time (US & Canada)", ending: "1972-01-23 11:00:00 Eastern Time (US & Canada)"})
shows.append oldsem.freeform_shows.create({name: "Fake Radio", weekday: 3, beginning: "1972-01-23 11:00:00 Eastern Time (US & Canada)", ending: "1972-01-23 12:00:00 Eastern Time (US & Canada)"})
shows.append oldsem.freeform_shows.create({name: "Freeform", weekday: 3, beginning: "1972-01-23 12:00:00 Eastern Time (US & Canada)", ending: "1972-01-23 13:00:00 Eastern Time (US & Canada)"})
shows.append oldsem.freeform_shows.create({name: "Freeform", weekday: 3, beginning: "1972-01-23 13:00:00 Eastern Time (US & Canada)", ending: "1972-01-23 15:00:00 Eastern Time (US & Canada)"})
shows.append oldsem.freeform_shows.create({name: "Uncle Jam Wants You", weekday: 3, beginning: "1972-01-23 15:00:00 Eastern Time (US & Canada)", ending: "1972-01-23 17:00:00 Eastern Time (US & Canada)"})
shows.append oldsem.freeform_shows.create({name: "Living Writers", weekday: 3, beginning: "1972-01-23 17:00:00 Eastern Time (US & Canada)", ending: "1972-01-23 18:00:00 Eastern Time (US & Canada)"})
shows.append oldsem.freeform_shows.create({name: "Polka Party", weekday: 3, beginning: "1972-01-23 18:30:00 Eastern Time (US & Canada)", ending: "1972-01-23 19:00:00 Eastern Time (US & Canada)"})
shows.append oldsem.freeform_shows.create({name: "Beat the Bezoar!", weekday: 3, beginning: "1972-01-23 19:00:00 Eastern Time (US & Canada)", ending: "1972-01-23 21:00:00 Eastern Time (US & Canada)"})
shows.append oldsem.freeform_shows.create({name: "Local Music Show", weekday: 3, beginning: "1972-01-23 21:00:00 Eastern Time (US & Canada)", ending: "1972-01-23 23:00:00 Eastern Time (US & Canada)"})
shows.append oldsem.freeform_shows.create({name: "Jammin' with Jack Straw", weekday: 3, beginning: "1972-01-23 23:00:00 Eastern Time (US & Canada)", ending: "1972-01-23 01:00:00 Eastern Time (US & Canada)"})
shows.append oldsem.freeform_shows.create({name: "Keeping it Copasetic", weekday: 4, beginning: "1972-01-23 01:00:00 Eastern Time (US & Canada)", ending: "1972-01-23 03:00:00 Eastern Time (US & Canada)"})
shows.append oldsem.freeform_shows.create({name: "Freeform", weekday: 4, beginning: "1972-01-23 03:00:00 Eastern Time (US & Canada)", ending: "1972-01-23 06:00:00 Eastern Time (US & Canada)"})
shows.append oldsem.freeform_shows.create({name: "Short Stack", weekday: 4, beginning: "1972-01-23 06:00:00 Eastern Time (US & Canada)", ending: "1972-01-23 09:00:00 Eastern Time (US & Canada)"})
shows.append oldsem.freeform_shows.create({name: "Jazz Til Noon", weekday: 4, beginning: "1972-01-23 09:00:00 Eastern Time (US & Canada)", ending: "1972-01-23 12:00:00 Eastern Time (US & Canada)"})
shows.append oldsem.freeform_shows.create({name: "Ceci n'est pas Freeform", weekday: 4, beginning: "1972-01-23 16:00:00 Eastern Time (US & Canada)", ending: "1972-01-23 18:00:00 Eastern Time (US & Canada)"})
shows.append oldsem.freeform_shows.create({name: "Pandora's Lunchbox", weekday: 4, beginning: "1972-01-23 18:30:00 Eastern Time (US & Canada)", ending: "1972-01-23 19:00:00 Eastern Time (US & Canada)"})
shows.append oldsem.freeform_shows.create({name: "Face the Music", weekday: 4, beginning: "1972-01-23 19:00:00 Eastern Time (US & Canada)", ending: "1972-01-23 20:00:00 Eastern Time (US & Canada)"})
shows.append oldsem.freeform_shows.create({name: "Sashay's Shimmy Ko-Ko Bop Hour", weekday: 4, beginning: "1972-01-23 20:00:00 Eastern Time (US & Canada)", ending: "1972-01-23 21:00:00 Eastern Time (US & Canada)"})
shows.append oldsem.freeform_shows.create({name: "Liberté, Égalité, Fréquence Modulée", weekday: 4, beginning: "1972-01-23 21:00:00 Eastern Time (US & Canada)", ending: "1972-01-23 22:00:00 Eastern Time (US & Canada)"})
shows.append oldsem.freeform_shows.create({name: "Freeform", weekday: 5, beginning: "1972-01-23 00:00:00 Eastern Time (US & Canada)", ending: "1972-01-23 03:00:00 Eastern Time (US & Canada)"})
shows.append oldsem.freeform_shows.create({name: "Freeform", weekday: 5, beginning: "1972-01-23 03:00:00 Eastern Time (US & Canada)", ending: "1972-01-23 06:00:00 Eastern Time (US & Canada)"})
shows.append oldsem.freeform_shows.create({name: "Freeform", weekday: 5, beginning: "1972-01-23 06:00:00 Eastern Time (US & Canada)", ending: "1972-01-23 09:00:00 Eastern Time (US & Canada)"})
shows.append oldsem.freeform_shows.create({name: "Freeform with Erin", weekday: 5, beginning: "1972-01-23 09:00:00 Eastern Time (US & Canada)", ending: "1972-01-23 12:00:00 Eastern Time (US & Canada)"})
shows.append oldsem.freeform_shows.create({name: "It's Hot in Here", weekday: 5, beginning: "1972-01-23 12:00:00 Eastern Time (US & Canada)", ending: "1972-01-23 13:00:00 Eastern Time (US & Canada)"})
shows.append oldsem.freeform_shows.create({name: "Consensual Radio", weekday: 5, beginning: "1972-01-23 13:00:00 Eastern Time (US & Canada)", ending: "1972-01-23 15:00:00 Eastern Time (US & Canada)"})
shows.append oldsem.freeform_shows.create({name: "Tight Pants", weekday: 5, beginning: "1972-01-23 15:00:00 Eastern Time (US & Canada)", ending: "1972-01-23 17:30:00 Eastern Time (US & Canada)"})
shows.append oldsem.freeform_shows.create({name: "Girl Power Half Hour", weekday: 5, beginning: "1972-01-23 17:30:00 Eastern Time (US & Canada)", ending: "1972-01-23 18:00:00 Eastern Time (US & Canada)"})
shows.append oldsem.freeform_shows.create({name: "Six O'Clock Shadow", weekday: 5, beginning: "1972-01-23 18:00:00 Eastern Time (US & Canada)", ending: "1972-01-23 19:00:00 Eastern Time (US & Canada)"})
shows.append oldsem.freeform_shows.create({name: "Leisure Experiment", weekday: 5, beginning: "1972-01-23 19:00:00 Eastern Time (US & Canada)", ending: "1972-01-23 20:00:00 Eastern Time (US & Canada)"})
shows.append oldsem.freeform_shows.create({name: "What It Is", weekday: 5, beginning: "1972-01-23 20:00:00 Eastern Time (US & Canada)", ending: "1972-01-23 22:00:00 Eastern Time (US & Canada)"})
shows.append oldsem.freeform_shows.create({name: "Freeform", weekday: 6, beginning: "1972-01-23 00:00:00 Eastern Time (US & Canada)", ending: "1972-01-23 03:00:00 Eastern Time (US & Canada)"})
shows.append oldsem.freeform_shows.create({name: "The Answer is in the Beat", weekday: 6, beginning: "1972-01-23 03:00:00 Eastern Time (US & Canada)", ending: "1972-01-23 06:00:00 Eastern Time (US & Canada)"})
shows.append oldsem.freeform_shows.create({name: "Soul Food Café", weekday: 6, beginning: "1972-01-23 06:00:00 Eastern Time (US & Canada)", ending: "1972-01-23 09:00:00 Eastern Time (US & Canada)"})
shows.append oldsem.freeform_shows.create({name: "American Vernacular", weekday: 6, beginning: "1972-01-23 09:00:00 Eastern Time (US & Canada)", ending: "1972-01-23 10:00:00 Eastern Time (US & Canada)"})
shows.append oldsem.freeform_shows.create({name: "Bill Monroe", weekday: 6, beginning: "1972-01-23 10:00:00 Eastern Time (US & Canada)", ending: "1972-01-23 12:00:00 Eastern Time (US & Canada)"})
shows.append oldsem.freeform_shows.create({name: "Down Home Show", weekday: 6, beginning: "1972-01-23 12:00:00 Eastern Time (US & Canada)", ending: "1972-01-23 15:00:00 Eastern Time (US & Canada)"})
shows.append oldsem.freeform_shows.create({name: "Nothin' But The Blues", weekday: 6, beginning: "1972-01-23 15:00:00 Eastern Time (US & Canada)", ending: "1972-01-23 17:00:00 Eastern Time (US & Canada)"})
shows.append oldsem.freeform_shows.create({name: "Robot Pasta", weekday: 6, beginning: "1972-01-23 17:00:00 Eastern Time (US & Canada)", ending: "1972-01-23 19:00:00 Eastern Time (US & Canada)"})
shows.append oldsem.freeform_shows.create({name: "Dancehall Reggae", weekday: 6, beginning: "1972-01-23 19:00:00 Eastern Time (US & Canada)", ending: "1972-01-23 21:00:00 Eastern Time (US & Canada)"})
shows.append oldsem.freeform_shows.create({name: "Freeform", weekday: 0, beginning: "1972-01-23 00:00:00 Eastern Time (US & Canada)", ending: "1972-01-23 03:00:00 Eastern Time (US & Canada)"})
shows.append oldsem.freeform_shows.create({name: "Freeform", weekday: 0, beginning: "1972-01-23 03:00:00 Eastern Time (US & Canada)", ending: "1972-01-23 06:00:00 Eastern Time (US & Canada)"})
shows.append oldsem.freeform_shows.create({name: "Dead White Guys", weekday: 0, beginning: "1972-01-23 06:00:00 Eastern Time (US & Canada)", ending: "1972-01-23 09:00:00 Eastern Time (US & Canada)"})
shows.append oldsem.freeform_shows.create({name: "Tsunami Dreams", weekday: 0, beginning: "1972-01-23 09:00:00 Eastern Time (US & Canada)", ending: "1972-01-23 10:00:00 Eastern Time (US & Canada)"})
shows.append oldsem.freeform_shows.create({name: "Turkish Delight", weekday: 0, beginning: "1972-01-23 10:00:00 Eastern Time (US & Canada)", ending: "1972-01-23 11:00:00 Eastern Time (US & Canada)"})
shows.append oldsem.freeform_shows.create({name: "Dromedary Express", weekday: 0, beginning: "1972-01-23 11:00:00 Eastern Time (US & Canada)", ending: "1972-01-23 12:00:00 Eastern Time (US & Canada)"})
shows.append oldsem.freeform_shows.create({name: "Jaffa Jive", weekday: 0, beginning: "1972-01-23 12:00:00 Eastern Time (US & Canada)", ending: "1972-01-23 13:00:00 Eastern Time (US & Canada)"})
shows.append oldsem.freeform_shows.create({name: "Latin Show", weekday: 0, beginning: "1972-01-23 13:00:00 Eastern Time (US & Canada)", ending: "1972-01-23 14:00:00 Eastern Time (US & Canada)"})
shows.append oldsem.freeform_shows.create({name: "Radiozilla", weekday: 0, beginning: "1972-01-23 14:00:00 Eastern Time (US & Canada)", ending: "1972-01-23 15:00:00 Eastern Time (US & Canada)"})
shows.append oldsem.freeform_shows.create({name: "Sounds of the Subcontinent", weekday: 0, beginning: "1972-01-23 15:00:00 Eastern Time (US & Canada)", ending: "1972-01-23 17:00:00 Eastern Time (US & Canada)"})
shows.append oldsem.freeform_shows.create({name: "Pan African Heartbeat", weekday: 0, beginning: "1972-01-23 17:00:00 Eastern Time (US & Canada)", ending: "1972-01-23 18:00:00 Eastern Time (US & Canada)"})
shows.append oldsem.freeform_shows.create({name: "Horizons", weekday: 0, beginning: "1972-01-23 18:00:00 Eastern Time (US & Canada)", ending: "1972-01-23 19:00:00 Eastern Time (US & Canada)"})
shows.append oldsem.freeform_shows.create({name: "Story Time", weekday: 0, beginning: "1972-01-23 19:00:00 Eastern Time (US & Canada)", ending: "1972-01-23 20:00:00 Eastern Time (US & Canada)"})
shows.append oldsem.freeform_shows.create({name: "Dim Your Lights", weekday: 0, beginning: "1972-01-23 20:00:00 Eastern Time (US & Canada)", ending: "1972-01-23 22:00:00 Eastern Time (US & Canada)"})
shows.append oldsem.freeform_shows.create({name: "Freeform", weekday: 4, beginning: "1972-01-23 12:00:00 Eastern Time (US & Canada)", ending: "1972-01-23 16:00:00 Eastern Time (US & Canada)"})
shows.append oldsem.freeform_shows.create({name: "Break Your Radio", weekday: 2, beginning: "1972-01-23 22:00:00 Eastern Time (US & Canada)", ending: "1972-01-23 23:59:59 Eastern Time (US & Canada)"})
shows.append oldsem.freeform_shows.create({name: "Crush Collision", weekday: 4, beginning: "1972-01-23 22:00:00 Eastern Time (US & Canada)", ending: "1972-01-23 23:59:59 Eastern Time (US & Canada)"})
shows.append oldsem.freeform_shows.create({name: "The Prescription", weekday: 5, beginning: "1972-01-23 22:00:00 Eastern Time (US & Canada)", ending: "1972-01-23 23:59:59 Eastern Time (US & Canada)"})
shows.append oldsem.freeform_shows.create({name: "Prop Shop", weekday: 6, beginning: "1972-01-23 21:00:00 Eastern Time (US & Canada)", ending: "1972-01-23 23:59:59 Eastern Time (US & Canada)"})
shows.append oldsem.freeform_shows.create({name: "The Seizure Experiment", weekday: 0, beginning: "1972-01-23 22:00:00 Eastern Time (US & Canada)", ending: "1972-01-23 23:59:59 Eastern Time (US & Canada)"})
shows.each{|s| Dj.all.sample.freeform_shows << s}
shows.each(&:propagate)

semester = Semester.create( beginning: "Tue, 12 May 2015 6:00:00 Eastern Time (US & Canada)", ending: "Tue, 15 September 2015 5:59:59 Eastern Time (US & Canada)" )

surrealist = cameron.freeform_shows.build(
  name: "Ceci n’est pas Freeform",
  weekday: 1,
  beginning: "1972-01-23 15:00:00 Eastern Time (US & Canada)",
  ending: "1972-01-23 17:30:00 Eastern Time (US & Canada)"
)
surrealist.semester = semester
surrealist.save
surrealist.propagate

bleached_meat = brandok.freeform_shows.build(
  name: "Bleached Meat",
  weekday: 1,
  beginning: "1972-01-23 12:00:00 Eastern Time (US & Canada)",
  ending: "1972-01-23 15:00:00 Eastern Time (US & Canada)"
)
bleached_meat.semester = semester
bleached_meat.save
bleached_meat.propagate

disco = semester.specialty_shows.build(
  name: "Drive Time Disco",
  weekday: 1,
  beginning: "1972-01-23 17:30:00 Eastern Time (US & Canada)",
  ending: "1972-01-23 18:30:00 Eastern Time (US & Canada)"
)
disco.coordinator = tyler
disco.save
disco.propagate

grey_matters = semester.talk_shows.build(
  name: "Grey Matters",
  weekday: 1,
  beginning: "1972-01-23 18:30:00 Eastern Time (US & Canada)",
  ending: "1972-01-23 19:00:00 Eastern Time (US & Canada)"
)
grey_matters.save
grey_matters.propagate

grey_matters.show_instances.create(
  beginning: "1972-01-23 18:30:00 Eastern Time (US & Canada)",
  ending: "1972-01-23 19:00:00 Eastern Time (US & Canada)"
)

slipstream = semester.freeform_shows.build({name: "SlipStream Radio", weekday: 1, beginning: "2000-01-01 06:00:00 Eastern Time (US & Canada)", ending: "2000-01-01 09:00:00 Eastern Time (US & Canada)"})
dwb.freeform_shows << slipstream
slipstream.save
slipstream.propagate

trying = semester.freeform_shows.create(
  name: "Trying Not To Swear",
  weekday: 0,
  beginning: "1972-01-23 03:00:00 Eastern Time (US & Canada)",
  ending: "1972-01-23 06:00:00 Eastern Time (US & Canada)"
)
tyler.freeform_shows << trying
trying.save
trying.propagate

six_oclock_shadow = semester.specialty_shows.create(
  name: "The Six O’Clock Shadow",
  weekday: 5,
  beginning: "1972-01-23 18:00:00 Eastern Time (US & Canada)",
  ending: "1972-01-23 19:00:00 Eastern Time (US & Canada)"
)
six_oclock_shadow.coordinator = Dj.find_by_name "Kristin Sumrall"
six_oclock_shadow.propagate
cameron.specialty_shows << six_oclock_shadow
brandok.specialty_shows << six_oclock_shadow

radiozilla = semester.specialty_shows.create(
  name: "Radiozilla",
  weekday: 0,
  beginning: "1972-01-23 14:00:00 Eastern Time (US & Canada)",
  ending: "1972-01-23 15:00:00 Eastern Time (US & Canada)"
)
radiozilla.coordinator = Dj.find_by_name "Mick Thorensen"
radiozilla.propagate
cameron.specialty_shows << radiozilla

#surr_first = surrealist.show_instances.create(
  #beginning: "Mon, 18 May 2015 15:00:00 Eastern Time (US & Canada)",
  #ending: "Mon, 18 May 2015 17:30:00 Eastern Time (US & Canada)"
#)

surr_first = surrealist.show_instances.starts_on_day Time.zone.parse("18 May 2015")
bm_first = bleached_meat.show_instances.starts_on_day Time.zone.parse("18 May 2015")
disco_first = disco.show_instances.starts_on_day Time.zone.parse("18 May 2015")

#bm_first = bleached_meat.show_instances.create(
  #beginning: "Mon, 18 May 2015 12:00:00 Eastern Time (US & Canada)",
  #ending: "Mon, 18 May 2015 15:00:00 Eastern Time (US & Canada)"
#)
bm_first.dj = dwb
bm_first.save

#disco_first = tyler.show_instances.build(
  #beginning: "Mon, 18 May 2015 17:30:00 Eastern Time (US & Canada)",
  #ending: "Mon, 18 May 2015 18:30:00 Eastern Time (US & Canada)"
#)
#disco.show_instances << disco_first
#disco.save
#disco_first.save

surr_first.songs.create([{
  artist: "Toro y Moi", name: "Lilly", album: "What For?", label: "Carpark",
  year: 2015, request: false, at: "Mon 18 May 2015 15:03:40"
},{
  artist: "Qrion", name: "Only", album: "Ssh#ffb6c1", label: "Secret Songs",
  year: 2014, request: false, at: "Mon 18 May 2015 15:08:14"
},{
  artist: "Best Coast", name: "In My Eyes", album: "California Nights",
  label: "Harvest", year: 2015, request: false,
  at: "Mon 18 May 2015 15:11:57"
},{
  artist: "Hiatus Kaiyote", name: "Molasses", album: "Choose Your Weapon",
  label: "Flying Buddha", year: 2015, request: false,
  at: "Mon 18 May 2015 15:15:05"
},{
  artist: "Stealing Sheep", name: "Deadlock", album: "Not Real",
  label: "Heavenly", year: 2015, request: false,
  at: "Mon 18 May 2015 15:21:37"
},{
  artist: "Rongetz Foundation", name: "Such a Morning Person", album: "Kiss Kiss Double Jab",
  label: "Heavenly Sweetness", year: 2015, request: false,
  at: "Mon 18 May 2015 15:23:48"
},{
  artist: "Chui Wan", name: "Beijing is Sinking (feat. Li Jianhong)", album: "Chui Wan",
  label: "Maybe Mars", year: 2015, request: false,
  at: "Mon 18 May 2015 15:30:51"
},{
  artist: "Lower Dens", name: "Your Heart Is Still Beating", album: "Escape from Evil",
  label: "Ribbon", year: 2015, request: false,
  at: "Mon 18 May 2015 15:37:51"
},{
  artist: "Mew", name: "Witness", album: "+-",
  label: "Play It Again Sam", year: 2015, request: false,
  at: "Mon 18 May 2015 15:43:36"
},{
  artist: "The Very Best", name: "Sweka", album: "Makes a King/Machokela Mafumu",
  label: "Moshimoshi", year: 2015, request: false,
  at: "Mon 18 May 2015 15:47:30"
},{
  artist: "Squarepusher", name: "Exjag Nives", album: "Damogen Furies",
  label: "Warp", year: 2015, request: false,
  at: "Mon 18 May 2015 15:54:14"
},{
  artist: "Vessels", name: "Glass Lake", album: "Dilate",
  label: "Bias", year: 2015, request: false,
  at: "Mon 18 May 2015 15:56:50"
},{
  artist: "Heroes of the Dancefloor", name: "I Could Never Get Involved", album: "Shelter",
  label: "Self-Released", year: 2014, request: false,
  at: "Mon 18 May 2015 16:03:58"
}])

bm_first.songs.create([{
  name: "Alone Again", artist: "The King Khan & BBQ Show",
  album: "Bad News Boys", label: "In The Red", year: 2005,
  request: false, at: "Mon, 18 May 2015 14:55:00"
},{
  name: "Autodidactic", artist: "Swervedriver",
  album: "I Wasn't Born To Lose You", label: "Cobraside", year: 2015,
  request: true, at: "Mon, 18 May 2015 14:25:00"
}])

legal_id = Signoff.create(
  on: "Legal ID",
  times: 7.times.map do |wday|
    24.times.map do |hr|
      {weekday: wday, at: Time.zone.parse("Tue, 12 May 2015 #{hr}:00:01")}
    end
  end.flatten
)

legal_id.signoff_instances.create([{
  on: "Legal ID",
  signed: "Brandon Kierdorf",
  at: "Mon, 18 May 2015 14:00:01"
},{
  on: "Legal ID",
  signed: "Cameron Bothner",
  at: "Mon, 18 May 2015 15:00:01"
}])

16.upto(20) do |i|
  legal_id.signoff_instances.create(
    on: "Legal ID",
    signed: nil,
    at: "Mon, 18 May 2015 #{i}:00:01"
  )
end

events_info = Signoff.create(
  on: "Events Information",
  times: 7.times.map do |wday|
    [1,4,7,10,13,16,20].map do |hr|
      {weekday: wday, at: Time.zone.parse("Tue, 12 May 2015 #{hr}:30:00")}
    end
  end
)
concert_info = Signoff.create(
  on: "Concert Information",
  times: 7.times.map do |wday|
    [2,5,8,11,14,17,21,23].map do |hr|
      {weekday: wday, at: Time.zone.parse("Tue, 12 May 2015 #{hr}:30:00")}
    end
  end
)

concert_info.signoff_instances.create([{
  on: "Concert Information",
  signed: "Brandon Kierdorf",
  at: "Mon, 18 May 2015 14:30:00"
}])
events_info.signoff_instances.create([{
  on: "Events Information",
  signed: nil,
  at: "Mon, 18 May 2015 16:30:00"
}])
