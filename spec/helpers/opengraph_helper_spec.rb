require 'spec_helper'

describe OpengraphHelper do
  include OpengraphHelper

  it "should render opengraph" do
    render_opengraph("og:title" => "wow", "og:description" => "hello to this site").should == "<meta content=\"wow\" property=\"og:title\" />\n<meta content=\"hello to this site\" property=\"og:description\" /><meta content=\"hello to this site\" name=\"description\" />"
  end

  it "should overwrite global data" do
    opengraph_data("og:title" => "local data", "og:noname" => "no name")
    render_opengraph("og:title" => "wow", "og:description" => "hello to this site").should == "<meta content=\"local data - nerdhub.de\" property=\"og:title\" />\n<meta content=\"hello to this site\" property=\"og:description\" />\n<meta content=\"no name\" property=\"og:noname\" /><meta content=\"hello to this site\" name=\"description\" />"
  end

end
