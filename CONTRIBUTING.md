# Contributing

**Please note that this project is released with a Contributor [Code of Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.**

In the spirit of [free software](http://www.fsf.org/licensing/essays/free-sw.html), **everyone** is encouraged to help improve this project – and we can assure you: there are a lot of things you can help us with. *You* can contribute by:

* trying out [master.hacken.in](https://master.hacken.in) and provide us with feedback
* reporting [bugs](https://github.com/hacken-in/hacken-in/issues/new)
* suggesting new features
* writing or editing documentation
* writing specifications
* writing code (**no patch is too small**: fix typos, add comments, write tests, clean up inconsistent whitespace)
* refactoring code
* discussing [issues](https://github.com/hacken-in/hacken-in/issues?milestone=7&state=open)
* reviewing pull requests

## Contributing Code aka. The Pamphlet

* If you need help setting this project up, check out the [README](README.md). If you run into problems setting up the project for development don't hesitate to [open an issue](https://github.com/hacken-in/hacken-in/issues/new).
* Pick a Ticket from the **Pick One** column at [waffle.io](http://waffle.io/hacken-in/hacken-in).
* Leave a comment that you want to work on this you ticket
* We will assign it to you and assist if you have any questions
* Start hacking
* Open a pull-request and work on a feature branch. During the work on your branch:
    * [Code Climate](http://codeclimate.com):rainbow: compares the "code quality" and the code coverage with the master branch. Both should stay the same or improve, never get worse.
    * A CI server provides feedback for your branch. We're using [Travis CI](http://travis-ci.org):construction_worker: to help us with this job.
* As soon as your feature is ready to be merged, you rebase the branch onto master and clean up your commit history
    * When you're ready, create a pull request.
    * We will review your branch and signal its readiness with a :shipit: or a GIF of our choosing. If there's feedback, we will discuss it with you. Don't worry - the worst thing that could happen to you, is being overwhelmed by a bunch of animated GIFs.
    * If you're good to go, we will click the shiny green 'Merge' button, and your ticket will be closed automatically.
    * Travis CI:construction_worker: runs the test suite, if everything is green, the master branch will be deployed to [master.hacken.in](https://master.hacken.in).
    * When we want to release it to production, we will make a pull request from the `master` branch to the `release` branch. Travis CI:construction_worker: will automatically deploy it.
* Welcome aboard! (You get extra points for deleting your old feature branch!)

## Deploying your Changes
* All changes that got merged into our `master` branch will automatically be published to [master.hacken.in](https://master.hacken.in). You can see the currently deployed revision right in the top left header bar
* Deployments to our live site [hacken.in](https://hacken.in) are done via [GitHub releases](https://github.com/hacken-in/hacken-in/releases) (which is just a fancy way to say "we're using Git tags"). To deploy the live site, just set a new tag on master via the GitHub interface. There is a simple rake task `rake release:changelog` will give you a list of all changes since the last Release.
