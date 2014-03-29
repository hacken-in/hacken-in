require "spec_helper"

describe Radar::Rss do

  let(:setting) {
    RadarSetting.create(url: "http://netzhansa.blogspot.com/feeds/posts/default?alt=rss")
  }

  it "should parse an rss feed" do
    VCR.use_cassette("rss_feed_events") do
      events = Radar::Rss.new(setting).next_events
      expect(events.count).to eq(4)

      event = events[1]
      expect(event[:id]).to eq("tag:blogger.com,1999:blog-3022969446495862761.post-7853420383787154846")
      expect(event[:url]).to eq("http://netzhansa.blogspot.com/2012/09/berlin-lispers-meetup-tue-oct-2-8-pm-st.html")
      expect(event[:title]).to eq("Berlin Lispers Meetup: Tue Oct 2, 8 pm @ St Oberholz: Lisp on RaspBerry Pi")
      expect(event[:description]).to eq((<<EOF
You are kindly invited to the next "Berlin Lispers Meetup", an informal gathering for anyone interested in Lisp, beer or coffee:
<br />
Berlin Lispers Meetup<br />
Tuesday Oct 2, 2012<br />
<b>8 pm</b> onwards<br />
<b>St Oberholz Café (not in the coworking space)<br/>
Rosenthaler Straße 72, 10119 Berlin</b><br />
U-Bahn Rosenthaler Platz<br />
<p>
There will be a presentation by Hans Hübner:

<h2>"The world's cheapest Lisp system"</h2>

The <a href="http://www.raspberrypi.org/">Raspberry Pi</a> has been the buzz in geek circles for some time now,
and finally the boards are readily available.  Running Lisp on it is
certainly the first thing a die-hard Lisper needs to try, and it works
pretty well - If not fast.  Hans hacked up some demo and is going to
show off how useable (or unusable, YMMV) <a href="http://ccl.clozure.com/">Clozure CL</a> is on this neat
board. At a base price of USD 35, arguably the cheapest system that
can run Common Lisp that has existed so far.
</p>
We will try to occupy the large table at the first level, but in case you
don't see us please contact Hans: 0177 512 1024.
<br />
Please join for another evening of parentheses!
<br />
- Hans Hübner &amp; Willem Broekema
EOF
                                      ).strip
                                     )
    end
  end

  it "should return everything that is newer than last_processed" do
    VCR.use_cassette("rss_feed_events") do
      setting.last_processed = Date.new(2010,1,1)
      events = Radar::Rss.new(setting).next_events
      expect(events.count).to eq(25)
    end
  end

end
