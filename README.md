# Readback
![Build Status](https://travis-ci.org/cbothner/readback.svg?branch=master) [![license](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)

Readback is how WCBN manages playlists, schedules, personnel, and trainees.

## Development

In order to work on Readback, you’ll need to install Ruby, Yarn, Postgres, and Redis. If you’re on a Mac, you can follow these instructions directly. Otherwise, hopefully they’re useful as Google fodder.

### Homebrew

The easiest way to install developer tools on macOS is Homebrew. Install it following [the instructions on their website](https://brew.sh/)

The package manager for Windows known as [Chocolately](https://chocolatey.org/) may (or may not) be useful.

### Ruby

We recommend using `rbenv` to install the necessary version of Ruby without conflicting with other things that use ruby.

```sh
brew install rbenv
cd readback
rbenv install  # This installs the version specified by the Gemfile
```

### Yarn

We use yarn to manage JavaScript dependencies. Install it by following [the instructions on their website](https://yarnpkg.com/en/docs/install#mac-stable)

### Postgres

PostgreSQL is our database. It is possible to install PostgreSQL using Homebrew, but it can be difficult to configure. We recommend using [Postgres.app](https://postgresapp.com/)

### Redis

Redis is a fast key-value store that we use for caching and for keeping track of background jobs that need to be done. Install Redis using Homebrew and configure it to load when your computer starts. It’s super lightweight, so there’s no reason not to configure it to do so.

```sh
brew install redis
ln -sfv /usr/local/opt/redis/*.plist ~/Library/LaunchAgents
```

### Overmind

Overmind will run all the processes needed for a developement server of Readback. Install it as follows:

```sh
brew install overmind
```

### Readback and its dependencies

After checking out the repo, run `bin/setup` to install dependencies.

Start the development server by running `overmind start`.  You can also run `bin/rails console` for an interactive prompt that will allow you to experiment.

Navigate to http://localhost:5000

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/cbothner/readback. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The project is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
