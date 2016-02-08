require 'spec_helper'

describe OpengraphHelper, type: :helper do
  include OpengraphHelper

  it "should render opengraph" do
    expect(render_opengraph("og:title" => "wow", "og:description" => "hello to this site")).to eq_html("<meta content=\"wow\" property=\"og:title\" />\n<meta content=\"hello to this site\" property=\"og:description\" /><meta content=\"hello to this site\" name=\"description\" />")
  end

  it "should overwrite global data" do
    opengraph_data("og:title" => "local data", "og:noname" => "no name")
    expect(render_opengraph("og:title" => "wow", "og:description" => "hello to this site")).to eq_html("<meta content=\"local data - hacken.in\" property=\"og:title\" />\n<meta content=\"hello to this site\" property=\"og:description\" />\n<meta content=\"no name\" property=\"og:noname\" /><meta content=\"hello to this site\" name=\"description\" />")
  end

end
