# Changelog

## 1.8 (2016-07-05)

* Emails rotating hosts and substitute DJs to remind them of their upcoming
  slots

## 1.7 (2016-04-05)

* Adds show descriptions and url fields
* Partial implementation of JSON API to feed player app

## 1.6 (2016-01-26)

* Sends emails to new trainees
* Adds public affairs log view

## 1.5.1 (2016-01-12)

* Fixes sorting and display issues on DJ profile views
* Makes the phone list visible for signed-in DJs

## 1.5 (2015-12-29)

* Adds full playlist search
* Adds autocompletion of album, label, year, etc.

## 1.4 (2015-12-18)

For Program Director:

* Enables one-off creation of new DJs
* Shows fulfilled sub requests all together

## 1.3 (2015-11-05)

* Infinite scrolling
* Adds local and new flags to songs

## 1.2.1 (2015-10-28)

* Asynchronous signoffs

## 1.2 (2015-10-08)

* Roster and phone list generation

## 1.1.1 (2015-09-30)

* Adds Turbolinks progress bar
* Caching
* Bugfixes

## 1.1 (2015-09-16)

* Makes songs reorderable
* Adds setbreaks

## 1.0 (2015-09-15)

* Official Launch

# Docker

## Build the Project

`docker-compose run web rails new . --force --database=postgresql`

Some changes require only `docker-compose up --build` but a full rebuild requires
a re-run of `docker-compose run web bundle install`

## Create the database

`docker-compose run web rake db:create`

[At some point you might have to `rm sudo rm tmp/pids/server.pid`](https://stackoverflow.com/questions/35022428/rails-server-is-still-running-in-a-new-opened-docker-container)
