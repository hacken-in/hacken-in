# Welcome

[![Build Status](https://secure.travis-ci.org/bitboxer/hcking.png)](http://travis-ci.org/bitboxer/hcking)

This is the code of [hcking.de](http://hcking.de). Hcking.de is an event
calendar for geeks in and around Cologne.

We discuss features and problems in our [google group](http://groups.google.com/group/hcking).

## Getting Started

If you want to work on the Project, follow the steps described here:

1. Fork the Project
1. Check out your fork
1. `cd` into the directory, install the bundler gem and run `bundle install`
1. Now create a database config: `cp config/database.yml_example config/database.yml`
  * The example config requires MySQL including a database and a user
  * You can instead use SQLite3
  * [More information](http://guides.rubyonrails.org/getting_started.html#configuring-a-database) on the database config
1. Now run `rake db:migrate` to setup your database
1. To run your application locally you can now use `rails server`
1. Now visit http://localhost:3000 in your webbrowser and you are ready to go!

If you want to add Events to your local page, you need an administrator:

1. Run `rake setup:admin user=USERNAME password=PASSWORD email=EMAIL`
1. Now you can log in with your new administrator ;)

## Using Guard, Spork and Pow for Development

*We currently have an [issue](https://github.com/bitboxer/hcking/issues/33) with our setup. Please read about the problem first.*

### Pow

Pow is a really comfortable way to run the application on your machine.
You can learn everything about it [here](http://pow.cx/).

### Guard

If you are in the project directory, you can start Guard with `guard`.
This will offer you the following comfortable features:

* **LiveReload:** If you are on Mac OS X and you have [livereload](http://livereload.com/) installed, your browser will automatically load changed CSS, JS and HTML data.
* **Pow:** Pow will get restarted automatically when necessary.
* **Bundler:** Bundler will run, when the Gemfile changes
* **Yard:** On http://localhost:8808 you will have a documentation
  server running
* **Spork:** A Spork instance will run in the background, which makes
  your tests faster
* **Test:** If you make changes to a test or a application file, the
  according tests will run and you will get feedback.

## Testing

Hcking is developed in a test-driven way using Test::Unit and
FactoryGirl. If you want to contribute to the project always add
tests for your added functionality. If you find a bug it would be
really helpful if you add a regression test that displays this
misbehaviour. Even better: Fix it afterwards ;)

## Note on Patches/Pull Requests

If you want to participate, feel free to fork and send us a pull request!

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so we don't break it in a future version unintentionally.
* Commit
* Send me a pull request. Bonus points for topic branches
