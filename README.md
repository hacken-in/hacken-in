# Welcome

[![Travis Build Status](https://img.shields.io/travis/hacken-in/hacken-in/master.svg?style=flat-square)](http://travis-ci.org/hacken-in/hacken-in)
[![Code Climate Maintainability](https://api.codeclimate.com/v1/badges/ea98e452e9c4715fea70/maintainability)](https://codeclimate.com/github/hacken-in/hacken-in/maintainability)
[![Code Climate Test Coverage](https://api.codeclimate.com/v1/badges/ea98e452e9c4715fea70/test_coverage)](https://codeclimate.com/github/hacken-in/hacken-in/test_coverage)
[![Cool Tickets](https://img.shields.io/waffle/label/hacken-in/hacken-in/ready.svg?label=Cool%20Tickets&style=flat-square)](https://waffle.io/hacken-in/hacken-in)
![bugsnag](https://img.shields.io/badge/bugsnag-%F0%9F%90%9B-green.svg?style=flat-square)
[![Contributer Coventant](https://img.shields.io/badge/contributor%20covenant-1.4-ff69bf.svg?style=flat-square)](http://contributor-covenant.org/version/1/4)

This is the code of [hacken.in](https://hacken.in), an event calendar for geeks in various cities.

* If you want to contribute, check out our [Code of Conduct](CODE_OF_CONDUCT.md) and [Contribution Guide](CONTRIBUTING.md).
* If you find a bug, please report it on our [tracker](https://github.com/hacken-in/hacken-in/issues).
* We discuss features and problems in our Slack.

## Scope of hacken.in :mag_right:

When you want to add an event to [hacken.in](https://hacken.in), we feature the following topics:

* Programming (in any language)
* Nerd-Culture (like Star Wars, Ponies, Gaming, Comics...)
* Software Development Methods and Software Engineering
* Electronics and Robots
* Networking

If you want to help us in extending the calendar to your city, [open an issue](https://github.com/hacken-in/hacken-in/issues/new), so we can get you started!

## Getting Started :point_right:

We use Docker and Docker Compose for development. Therefore you need to follow the following steps to develop for hacken.in:

* Install Docker and Docker Compose
    * If you’re using macOS, install [Docker for Mac](https://docs.docker.com/docker-for-mac)
    * If you’re using Windows, install [Docker for Windows](https://docs.docker.com/docker-for-windows)
    * If you’re using Linux, install [Docker](https://docs.docker.com/engine/installation/linux) and [Docker Compose](https://docs.docker.com/compose/install)
* Clone this repository
* In the folder now run `./bin/setup`

You are now ready to go :smile: The app should be available at [http://localhost:3000](http://localhost:3000). If that's not the case, please ping us on Slack :smile:

If you want to start your app again later, run `docker-compose up`. For all other commands you want to run, you always prefix them with `docker-compose run --rm web`. A few examples:

* Run all tests with `docker-compose run --rm web rake`
* Run the migrations with `docker-compose run --rm web rake db:migrate`
* Generate a model `MyModel` with `docker-compose run --rm web rails generate model MyModel`

## Contributing to Hacken.in :tada:

Please note that this project is released with a Contributor [Code of Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.

Learn everything about Contributing in our [CONTRIBUTING.md](CONTRIBUTING.md) :heart:

## Exception Tracking :bug:

We use [bugsnag](https://www.bugsnag.com) for exception tracking. When an exception occurs on our live page, this will create a ticket in Github.

## Communication :speech_balloon:

If you want to drink from the firehose (and see a lot of GIFs) join us in our [Slack room](https://hacken-in.slack.com). Just ping us [on Twitter](https://twitter.com/hacken_in) or send an email to admin@hacken.in and we will add you.
