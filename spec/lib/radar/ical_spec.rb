require "spec_helper"

describe Radar::Ical do

  let(:setting) {
    RadarSetting.create(url: "http://vimberlin.de/vimberlin.ics")
  }

  it "should get the next events for a meetup" do
    VCR.use_cassette('vim berlin ical feed') do
      events = Radar::Ical.new(setting).next_events
      expect(events.length).to eq(18)
      event = events[1]
      expect(event[:id]).to eq("2014-01-23T19:30:00+00:00")
      expect(event[:url]).to eq("http://vimberlin.de/january-2014-meetup")
      expect(event[:title]).to eq("January 2014 Meetup")
      expect(event[:description]).to eq(<<EOF
Happy new year and we start again with our monthly meetups in 2014.


## Talks


* **"Using Vimperator to browse the Web"** by [Matthias Günther](https://twitter.com/wikimatze)

    I switched over to Vimperator one month ago and would like to show you shortcuts and how you can configure it.

     "Using Vimperator to browse the Web" by Matthias Günther from wikimatze on Vimeo.
* **"Clever autocommands"** by [Andrew Radev](https://twitter.com/andrewradev)

    I'm going to do a quick overview on autocommands and some gotchas in their usage. I assume that most people present will know this stuff already, but there might be one or two things you may not have known before :).

    I'll talk about some clever ways I use autocommands. I'll also show my unfinished experiments with a recently-added autocommand called `TextChanged`. This allows you to hook into any kind of change in both normal and insert mode, with some gotchas...

    I'm hoping that many other attendees will pitch in for ideas about interesting autocommands they use, opening up some discussion after the talk.

     “Clever autocommands” by Andrew Radev from wikimatze on Vimeo.
* **"Writing text in Vim"** by [Florian Eitel](http://feitel.indeedgeek.de/)

    I like to show some tricks and snippets I use for working with text. This include using the spell checker in multiple languages, break long lines, full text search using vimgrep and maybe more.

     “Writing text in Vim” by Florian Eitel from wikimatze on Vimeo.
    • [SLIDES](/data/vimberlin-2014-01_vim_writing.html)

* **Blame your vimrc** [Matthias](https://twitter.com/der_kronn) showing his [vimrc](https://github.com/kronn/dotfiles/blob/master/.vimrc)

     “vimrc" by Matthias Viehweger from wikimatze on Vimeo.

If you want to give a talk too, send us a tweet or a mail.

Thanks to [Travis CI](https://travis-ci.org/) for hosting this event.


**[Matthias Günther](http://wikimatze.de/about.html "Matthias Günther")**



## Recap


### Vim News

This is a new part in our meetup. [Andrew](https://twitter.com/andrewradev) will talk about the latest things happening in our Vim community like stuff posted in reddit, discussions on the mailing list, some new plugin or new mapping that someone tweeted. If we get positive feedback about this idea, we make will make this a daily habbit to every following meetup.

#### Plugins:
- [Exchange plugin](https://github.com/tommcdo/vim-exchange)
- [Sneak.vim](https://github.com/justinmk/vim-sneak)
- [Easyclip](https://github.com/svermeulen/vim-easyclip)


#### Builtins:
- [:set writedelay](http://www.reddit.com/r/vim/comments/1uq71v/a_gimmicky_but_potentially_useful_option/)


#### Twitter:
- [Zip right](https://twitter.com/dotvimrc/status/424236516030685184)


#### Vim mailing list:
- [Check existence of function for version](https://groups.google.com/forum/#!topic/vim_dev/UGPhorNh_3E)
- [Non-blocking jobs](https://groups.google.com/forum/#!topic/vim_dev/QF7Bzh1YABU)
- [Input queue](https://groups.google.com/forum/#!topic/vim_dev/65jjGqS1_VQ)
- [Named builtins](https://groups.google.com/forum/#!topic/vim_dev/dcy_0HJ3RC0)
- [Complete rewrite](https://groups.google.com/forum/#!topic/vim_dev/drZDXZmYBsY)

EOF
)
      expect(event[:venue]).to eq("GanzOben Office at Betahaus (Travis CI office, 5Apps, Avarteq, Cileos), Prinzessinnenstr. 20, 10969 Berlin, Kreuzberg, Germany")
      expect(event[:duration]).to eq(180)
      expect(event[:time].utc).to eq(Time.utc(2014,1,23,19,30,00))
    end
  end

end
