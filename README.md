# Welcome

[![Build Status](https://secure.travis-ci.org/bitboxer/hcking.png)](http://travis-ci.org/bitboxer/hcking)

This is the code of [hcking.de](http://hcking.de). Hcking.de is an event
calendar for geeks in and around Cologne.

We discuss features and problems in our google group that can be found [here](http://groups.google.com/group/hcking).

## Getting Started

If you want to work on the Project, follow the steps described here:

1. Fork the Project
2. Check out your fork
3. `cd` into the directory, install the bundler gem and run `bundle install`
4. Now create a database config: `cp config/database.yml_example config/database.yml`
  * The example config requires MySQL including a database and a user
  * You can instead use SQLite3
  * [More information](http://guides.rubyonrails.org/getting_started.html#configuring-a-database) on the database config
5. Now run `rake db:migrate` to setup your database
6. To run your application locally you can now use `rails server`
7. Now visit http://localhost:3000 in your webbrowser and you are ready to go!

If you want to add Events to your local page, you need an administrator:

1. Run `rake setup:admin user=USERNAME password=PASSWORD email=EMAIL`
2. Now you can log in with your new administrator ;)

## Note on Patches/Pull Requests

If you want to participate, feel free to fork and send us a pull request!

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a future version unintentionally.
* Commit
* Send me a pull request. Bonus points for topic branches
