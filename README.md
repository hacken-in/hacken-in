# Welcome

[![Build Status](https://secure.travis-ci.org/hacken-in/website.png?branch=master)](http://travis-ci.org/hacken-in/website)
[![Code Climate](https://codeclimate.com/github/hacken-in/website.png)](https://codeclimate.com/github/hacken-in/website)
[![Coverage Status](https://coveralls.io/repos/hacken-in/website/badge.png)](https://coveralls.io/r/hacken-in/website)
[![Stories in Ready](https://badge.waffle.io/hacken-in/website.png?label=ready&title=Ready)](https://waffle.io/hacken-in/website)

This is the code of [hacken.in](http://hacken.in/), an event calendar for geeks in and around Cologne, Berlin and Munich.
If you want to help us in extending the calendar to your city, please contact us in our [Google Group](http://groups.google.com/group/hacken-in).

If you find a bug, please report it on our [tracker](https://github.com/hacken-in/website/issues). We discuss features and problems in our [Google Group](http://groups.google.com/group/hcking). You can find our backlog [here](https://github.com/hacken-in/website/wiki/Backlog).

## Scope of hacken.in

When you want to add an event to [hacken.in](http://hacken.in) please check with the following guidelines:

* Currently we only feature events in Ruhr area, Berlin and Munich plus BIG events in Europe
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
  * The example config requires PostgreSQL including a database and a user
  * [More information](http://guides.rubyonrails.org/getting_started.html#configuring-a-database) on the database config
1. Create the Devise & Omniauth configuration `cp config/initializers/devise.rb_example config/initializers/devise.rb` and edit the keys
1. Now run `rake db:migrate db:seed` to setup your database. You will now have an admin user `admin@hacken.local` with the password `hacken_admin`
1. To run your application locally you can now use `rails server`
1. Now visit http://localhost:3000 in your webbrowser and you are ready to go!

## Booting up the Vagrant VM

Hacken.in can also be started in a virtual machine with Vagrant. This might be the perfect fit if you cannot or don't want to install 
PostgreSQL or MySQL on your computer. To get started with Vagrant, install the latest version of [Vagrant](http://www.vagrantup.com) and
[VirtualBox](https://www.virtualbox.org), and check out your fork of the project (see *Getting Started*).

In your working copy, run our bootstrap task, to install all required puppet modules (you only have to do this once):

```bash
$ bundle exec rake setup:vagrant
```

To start up the VM, type:

```bash
$ vagrant up
```

If the Vagrant exits successfully, you can access your local machine under the URL [hacken.local](http://hacken.local). All the files you
change in your local folder are synced to the virtual machines, so you can work on hacken.in right away. :wrench:

![hacken.local](https://i.imgur.com/rGh0pwE.png)

If you're experiencing problems do not hesitate to contact us or - even better - file an issue.

### Communication

You can reach us on lots of ways. The most prefered one would be either to open an issue here or to use our [Google Group](http://groups.google.com/group/hacken-in). If you want to drink from the firehose (and see a lot of GIFs) join us in our Slack room. In order to get invited, just ping us via admin@hacken.in and we will add you.

### Waffle.io

We use [waffle.io](http://waffle.io/hacken-in/website) to manage our tickets. Everyhing in the "ready" state is ready to be implemented.

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
