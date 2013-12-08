# Welcome

[![Build Status](https://secure.travis-ci.org/hcking/hcking.png?branch=master)](http://travis-ci.org/hcking/hcking)
[![Code Climate](https://codeclimate.com/github/hcking/hcking.png)](https://codeclimate.com/github/hcking/hcking)
[![Coverage Status](https://coveralls.io/repos/hcking/hcking/badge.png)](https://coveralls.io/r/hcking/hcking)

This is the code of [hacken.in](http://hacken.in/), an event
calendar for geeks in and around Cologne and Berlin.

We discuss features and problems in our [Google Group](http://groups.google.com/group/hcking).

## Scope of hacken.in

When you want to add an event to [hacken.in/koeln](http://hacken.in/koeln) please check with the following guidelines:

* Currently we only feature events in Ruhr area plus BIG events in Europe
* The following topics are allowed:
  * Programming (in any language)
  * Nerd-Culture (like Star Wars, Ponies, Gaming, Comics...)
  * Software Development Methods and Software Engineering
  * Electronics and Robots
  * Networking

## Getting Started

If you want to work on the Project, follow the steps described here:

1. Fork the Project
1. Check out your fork
1. `cd` into the directory, install the bundler gem and run `bundle install`
1. Now create a database config: `cp config/database.yml_example config/database.yml`
  * The example config requires MySQL including a database and a user
  * You can instead use SQLite3
  * [More information](http://guides.rubyonrails.org/getting_started.html#configuring-a-database) on the database config
1. Create the Devise & Omniauth configuration `cp config/initializers/devise.rb_example config/initializers/devise.rb` and edit the keys
1. Now run `rake db:migrate` to setup your database
1. To run your application locally you can now use `rails server`
1. Now visit http://localhost:3000 in your webbrowser and you are ready to go!

If you want to add Events to your local page, you need an administrator:

1. Run `rake setup:admin`
1. Now you can log in with your new administrator ;)

### Pow

Pow is a really comfortable way to run the application on your machine.
You can learn everything about it [here](http://pow.cx).

### Guard

If you are in the project directory, you can start Guard with `guard`.
This will offer you the following comfortable features:

* **Pow:** Pow will get restarted automatically when necessary.
* **Bundler:** Bundler will run, when the Gemfile changes
  server running
* **Specs:** If you make changes to a spec or an application file, the
  according spec will be run and you will get feedback.

## Testing

[Hacken.in](http://hacken.in) is developed in a test-driven way using Rspec and
FactoryGirl. If you want to contribute to the project always add
tests for your added functionality. If you find a bug it would be
really helpful if you add a regression test that displays this
misbehaviour. Even better: Fix it afterwards ;)

## Note on Patches/Pull Requests

See [CONTRIBUTING.md](CONTRIBUTING.md) for details
