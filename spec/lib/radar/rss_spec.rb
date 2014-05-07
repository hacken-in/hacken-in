require "spec_helper"

describe Radar::Rss do

  let(:setting) {
    RadarSetting.create(url: "http://netzhansa.blogspot.com/feeds/posts/default?alt=rss")
  }

  it "should parse an rss feed" do
    events = Radar::Rss.new(setting).next_events
    expect(events.count).to eq(4)

    event = events[1]
    expect(event[:id]).to eq("tag:blogger.com,1999:blog-3022969446495862761.post-3360184680704008728")
    expect(event[:url]).to eq("http://netzhansa.blogspot.com/2012/12/drakma-documentation-updates.html")
    expect(event[:title]).to eq("DRAKMA documentation updates")
    expect(event[:description]).to eq((<<EOF
<p>
The <a href="http://weitz.de/drakma" target="drakma">DRAKMA documentation</a> has received a big overhaul to bring the docstrings and the HTML documentation in sync again.  I also restructured the large example section in the beginning so that the individual <a href="http://weitz.de/drakma/#examples" target="drakma">examples are indexed</a>.  I also added changed two examples so that they deal with <a href="http://weitz.de/drakma/#ex-binary-data" target="drakma">JSON</a> <a href="http://weitz.de/drakma/#ex-response-stream" target="drakma">data</a> as JSON is so popular nowadays.
</p>
<h1>DRAKMA and JSON</h1>
<p>
A user suggested that DRAKMA should handle JSON data like text data, i.e. that the content type "application/json" should, by default, be on the <a href="http://weitz.de/drakma/#*text-content-types*" target="drakma">list of text content types</a>.  The issue with that suggestion is that <a href="http://www.ietf.org/rfc/rfc4627.txt" target="rfc4627">JSON data</a> is not following the encoding rules for text content type.  By default, JSON data is encoded in UTF-8.  It is possible to use UTF-16 and UTF-32 by the way of a byte order mark transmitted in the beginning of the file.  For textual content types, the character set is determined by the charset parameter in the Content-Type header, which is not used with "application/json".
</p>
<p>
I have thought about adding a DRAKMA:HTTP-JSON-REQUEST function that would deal with JSON encoding properly, but I think such a function would rather belong into a JSON library than into DRAKMA, so it is left out for now.
</p>
<h1>How useful are docstrings, really?</h1>
<p>
Getting the docstrings and the documentation into sync again was pretty laborious, and I fear that I have been missing quite a few things that were in one version of the documentation, but not in the other.  So far, Edi and I have used a forward-annotation strategy where the initial version of the documentation was created off the docstrings in the source code, and then manually edited to contain links and other niceties that real documentation deserves.  This, of course, is a pretty bad strategy, as edits must be repeated or the docstrings need to contain some form of markup so that no edits are needed.
</p>
<p>
Going forward, I will probably start to generate docstrings from the XML documentation source.  That way, the documentation source can contain links and other, more advanced markup that is not useful in docstrings, and the two representations will not go out of sync.  The docstrings will no longer be inline with the source code, but go into a separate file that is generated as part of the release process.
</p>
<p>
Any thoughts?  Use comments or <a href="mailto:hans.huebner@gmail.com" target="_new">send email</a>.
EOF
                                      ).strip
                                     )
  end

  it "should return everything that is newer than last_processed" do
    setting.last_processed = Date.new(2010,1,1)
    events = Radar::Rss.new(setting).next_events
    expect(events.count).to eq(25)
  end

end
