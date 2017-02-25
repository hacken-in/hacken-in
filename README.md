# Welcome

[![Travis Build Status](https://img.shields.io/travis/hacken-in/hacken-in/master.svg)](http://travis-ci.org/hacken-in/hacken-in)
[![Code Climate](https://img.shields.io/codeclimate/github/hacken-in/hacken-in.svg)](https://codeclimate.com/github/hacken-in/hacken-in)
[![Code Climate CodeCoverage](https://img.shields.io/codeclimate/coverage/github/hacken-in/hacken-in.svg)](https://codeclimate.com/github/hacken-in/hacken-in)
[![Cool Tickets](https://img.shields.io/waffle/label/hacken-in/hacken-in/ready.svg?label=Cool%20Tickets)](https://waffle.io/hacken-in/hacken-in)

This is the code of [hacken.in](https://hacken.in), an event calendar for geeks in various cities.

* If you want to help us in extending the calendar to your city, please contact us in our [Google Group](http://groups.google.com/group/hacken-in).
* If you find a bug, please report it on our [tracker](https://github.com/hacken-in/hacken-in/issues).
* We discuss features and problems in our Slack.
* If you want to contribute to [hacken.in](https://hacken.in), have a look at our Kanban Board at [waffle.io](http://waffle.io/hacken-in/hacken-in). Just pick a card from the **Pick One** column and start hacking.

## Scope of hacken.in

When you want to add an event to [hacken.in](https://hacken.in), we feature the following topics:

* Programming (in any language)
* Nerd-Culture (like Star Wars, Ponies, Gaming, Comics...)
* Software Development Methods and Software Engineering
* Electronics and Robots
* Networking

## Getting Started

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

### Communication

If you want to drink from the firehose (and see a lot of GIFs) join us in our [Slack room](https://hacken-in.slack.com). Just ping us [on Twitter](https://twitter.com/hacken_in) or send an email to admin@hacken.in and we will add you.

## Testing

[Hacken.in](https://hacken.in) is developed in a test-driven way using RSpec and FactoryGirl. If you want to contribute to the project always add tests for your added functionality. If you find a bug it would be really helpful if you add a regression test that displays this misbehavior. Even better: Fix it afterwards :wink:

## About Contributing

Please note that this project is released with a Contributor [Code of Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.

See [CONTRIBUTING.md](CONTRIBUTING.md) for details
