require 'test_helper'

class OpengraphHelperTest < ActionView::TestCase
  include OpengraphHelper

  test "should render opengraph" do
    assert_equal "<meta content=\"wow\" property=\"og:title\" />\n<meta content=\"hello to this site\" property=\"og:description\" /><meta content=\"hello to this site\" name=\"description\" />", 
      render_opengraph("og:title" => "wow", "og:description" => "hello to this site")
  end

  test "page data should overwrite global data" do
    opengraph_data("og:title" => "local data", "og:noname" => "no name")
    assert_equal "<meta content=\"local data - nerdhub.de\" property=\"og:title\" />\n<meta content=\"hello to this site\" property=\"og:description\" />\n<meta content=\"no name\" property=\"og:noname\" /><meta content=\"hello to this site\" name=\"description\" />",
      render_opengraph("og:title" => "wow", "og:description" => "hello to this site")
  end

end
