require "spec_helper"

describe Radar::Onruby do

  let(:setting) {
    RadarSetting.create(url: "http://berlin.onruby.de")
  }

  it "should get the next events for a meetup" do
    VCR.use_cassette('onruby_berlin_events') do
      events = Radar::Onruby.new(setting).next_events
      expect(events.length).to eq(10)
      event = events[1]
      expect(event[:id]).to eq(127)
      expect(event[:url]).to eq("http://berlin.onruby.de/events/127")
      expect(event[:title]).to eq("February Meetup 2014")
      expect(event[:description]).to eq(
        "<p>Let's meet to hear about Ruby and related technologies!</p>"+
        "<p>Customizable Gems [lightning talk] - Nico Hagenburger</p>"+
        "<p>Add some hooks/callbacks</p>"+
        "<p>Getting started with open source [lightning] - Philipp Hansch</p>"+
        "<p>How do you find your first open source project and what you might want to know before starting to work on issues. I recently started contributing to open source projects and want to encourage others to do so as well. </p>"+
        "<p>Assets on Rails - Grzesiek Kolodziejczyk</p>"+
        "<p>There are several approaches to managing external frontend libraries with the Rails asset pipeline. The talk would first go through the most popular (vendoring, _-rails gems, bower) and show a relatively new one: Rails Assets.</p>\n\n"+
        "<p>Rails Assets automatically converts bower packages into rubygems, and serves them in a bundler compatible way.</p>\n\n"+
        "<p>This can also be shortened into a lightning talk.</p>"+
        "<p>Tricky testing - Andrew Radev</p>"+
        "<p>Theoretically, testing is pretty easy. Prepare some data, perform some operations on it, check the result. This description often doesn't paint the full picture. For instance, how do you test:</p>\n\n"+
        "<p>- Deploy scripts, like a bunch of tasks you've built on top of capistrano?\n<br />"+
        "- Networking code: sockets, asynchronous streams?\n<br />"+
        "- Inter-process communication?\n<br />"+
        "- GUIs?</p>\n\n"+
        "<p>I don't have easy testing solutions for the above. There *are* options, but I think we can agree there's a category of programming problems that can be tricky to test. And I think it's common that, when faced with such problems, we're strongly inclined to avoid testing altogether.</p>\n\n"+
        "<p>So is it okay to skip tests in these cases? Or should we put effort into testing every little thing, even if it takes weeks to set up and ends up breaking randomly?</p>\n\n"+
        "<p>I'm going to give my thoughts on the matter, taking examples from spork, and from some of my own projects, like a Vimscript test runner and a tool that runs a rails command with music in the background. I'll also demonstrate how Vim plugins can be tested with rspec. These projects need more work than just setting up data and performing method calls, but once you've built a good toolkit, the specs flow quite nicely. Whether you *should* invest the time and energy is a question I'll try to address.</p>"+
        "<p>Easy hadoop scheduling with JRuby and Sinatra - Pere Urbón</p>"+
        "<p>During the development of our internal hadoop reporting engine we encounter with the need of an easy to deal with scheduler, so we ask for help to our beloved Ruby friends. In this talk we aim to show, and discuss, how easy is to create a simple hadoop scheduler thanks to JRuby, Sinatra, Neo4j and some other gems.</p>\n\n"+
        "<p>Time (aprox): 20 minutes -/+ 5 minutes for questions.\n<br />"+
        "---\n<br />"+
        "* Written and directed by: Pere Urbon-Bayes and Achim Friedland.\n<br />"+
        "* Producers: Belectric IT Solution Gmbh.\n<br />"+
        "* Cast: \n<br />"+
        "* Ruby     as The programing language.\n<br />"+
        "* JRuby   as The virtual machine.\n<br />"+
        "* Sinatra  as The web framework.\n<br />"+
        "* Hadoop as The data processing framework.\n<br />"+
        "* PIG       as The scripting language.\n<br />"+
        "* Design effects:\n<br />"+
        "* Apache PDFBox as The PDF craftsman.\n<br />"+
        "* JFreeChart as The Charting director.\n<br />"+
        " ---\n</p>")
      expect(event[:time].utc).to eq(Time.utc(2014,02,06,18,30,00))
      expect(event[:venue]).to eq("Votum,  Mehringdamm 53-55, 10961 Berlin, http://www.votum.de/")
    end
  end

end
