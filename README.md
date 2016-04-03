# Welcome

[![Travis Build Status](https://img.shields.io/travis/hacken-in/website/master.svg)](http://travis-ci.org/hacken-in/website)
[![Codeship Build Status](https://img.shields.io/codeship/3c775da0-bbc6-0131-1826-124bbd4fc581/master.svg)](https://codeship.com/projects/20985)
[![Code Climate](https://img.shields.io/codeclimate/github/hacken-in/website.svg)](https://codeclimate.com/github/hacken-in/website)
[![Code Climate CodeCoverage](https://img.shields.io/codeclimate/coverage/github/hacken-in/website.svg)](https://codeclimate.com/github/hacken-in/website)
[![Pickable Stories](https://badge.waffle.io/hacken-in/website.png?label=ready&title=Pick One)](https://waffle.io/hacken-in/website)

This is the code of [hacken.in](http://hacken.in/), an event calendar for geeks in and around Cologne, Ruhr area, Berlin, Hamburg and Munich.
If you want to help us in extending the calendar to your city, please contact us in our [Google Group](http://groups.google.com/group/hacken-in).

If you find a bug, please report it on our [tracker](https://github.com/hacken-in/website/issues). We discuss features and problems in our [Google Group](http://groups.google.com/group/hcking). If you want to contribute to [hacken.in](http://hacken.in), have a look at our Kanban Board at [waffle.io](http://waffle.io/hacken-in/website). Just pick a card from the **Pick One** column and start hacking. This is our current activity level:

[![Throughput Graph](https://graphs.waffle.io/hacken-in/website/throughput.svg)](https://waffle.io/hacken-in/website/metrics)

## Scope of hacken.in

When you want to add an event to [hacken.in](http://hacken.in) please check with the following guidelines:

* Currently we only feature events in Cologne, Ruhr area, Berlin and Munich plus BIG events in Germany
* The following topics are allowed:
  * Programming (in any language)
  * Nerd-Culture (like Star Wars, Ponies, Gaming, Comics...)
  * Software Development Methods and Software Engineering
  * Electronics and Robots
  * Networking

## Getting Started

If you want to work on hacken.in you have two options:

1. Use our Vagrant VM.

   The best method if you haven't tried Rails before and don't want to
   install PostgreSQL on your computer.

1. Start hacken.in locally with Pow

   If you already have Pow and a local PostgreSQL installation, you
   are good to go. Just skip to the section `Using Pow`.

### Using the Vagrant VM

Hacken.in can also be started in a virtual machine with Vagrant. This might be the perfect fit if you cannot or don't want to install PostgreSQL or MySQL on your computer. To get started with Vagrant, install the latest version of [Vagrant](http://www.vagrantup.com) and [VirtualBox](https://www.virtualbox.org), and check out your fork of the project (see *Getting Started*).

Once your checkout is ready, type the following command into your terminal and our friendly setup assistant should take over from there on:

```bash
$ script/bootstrap
```

Once it is done, point your browser to [hacken.local](http://hacken.local). All the files you change in your local folder are synced to the virtual machines, so you can work on hacken.in right away. :wrench:

If you use filesystem encryption, you might receive an error similar to `mount.nfs: mount to NFS server '.../' failed: timed out, giving up`. In this case, edit the Vagrantfile and uncomment the line:

```ruby
config.vm.synced_folder ".", "/opt/hacken.in", type: 'rsync', rsync__args: ['-a']
```

Afterwards local code can to be re-synced to the VM via `$ vagrant rsync-auto` which you can run in the background.

![hacken.local](https://i.imgur.com/rGh0pwE.png)

If you run into any problems: Don't be afraid to tell us on [Twitter](https://twitter.com/hacken_in) or open a ticket.

### Using Pow

1. Fork the Project
1. Check out your fork
1. `cd` into the directory, install the bundler gem and run `bundle install`
1. Now create a database configuration: `cp config/database.yml_example config/database.yml`
  * The example configuration requires PostgreSQL including a database and a user
  * [More information](http://guides.rubyonrails.org/getting_started.html#configuring-a-database) on the database configuration
1. Now run `rake db:migrate db:seed` to setup your database. You will now have an admin user `admin@hacken.local` with the password `hacken_admin`
1. To run your application locally you can now use `rails server`
1. Now visit http://localhost:3000 in your web browser and you are ready to go!

### Communication

You can reach us on lots of ways. The most preferred one would be either to open an issue here or to use our [Google Group](http://groups.google.com/group/hacken-in). If you want to drink from the firehose (and see a lot of GIFs) join us in our [Slack room](https://hacken-in.slack.com). Just ping us [on Twitter](https://twitter.com/hacken_in) or send an email to admin@hacken.in and we will add you.

### Guard

If you are in the project directory, you can start Guard with `guard`.
This will offer you the following comfortable features:

* **Pow:** Pow will get restarted automatically when necessary.
* **Bundler:** Bundler will run, when the Gemfile changes
  server running
* **Specs:** If you make changes to a spec or an application file, the
  according spec will be run and you will get feedback.

## Testing

[Hacken.in](http://hacken.in) is developed in a test-driven way using RSpec and FactoryGirl. If you want to contribute to the project always add tests for your added functionality. If you find a bug it would be really helpful if you add a regression test that displays this misbehavior. Even better: Fix it afterwards :wink:

## About Contributing

Please note that this project is released with a Contributor [Code of Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.

See [CONTRIBUTING.md](CONTRIBUTING.md) for details
