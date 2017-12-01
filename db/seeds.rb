PlaylistEditor.create email: 'radio@wcbn.org', password: 'password'

admin = Dj.create name: 'Developer Admin', phone: '(734) 763-3500',
                  email: 'radio@wcbn.org', password: 'password'
admin.add_role :superuser
admin.add_role :grandfathered_in
admin.add_role :stage_one_trainer

semester = Semester.create beginning: Date.today, ending: 15.weeks.since

top_of_the_hour = Time.zone.now.at_beginning_of_hour
show = semester.freeform_shows.build name: 'Freeform', dj: admin
show.set_times_conditionally_from_params weekday: top_of_the_hour.wday,
                                         beginning: top_of_the_hour.to_json,
                                         duration: 3
show.save
show.propagate(top_of_the_hour, semester.ending)

episode = show.most_recent_episode
episode.songs.create at: Time.zone.now, name: 'Changes', artist: 'David Bowie',
                     album: 'Hunky Dory', year: 1971, label: 'Parlophone'
