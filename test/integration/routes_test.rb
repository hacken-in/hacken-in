require 'test_helper'

class RoutesTest < ActionDispatch::IntegrationTest
  fixtures :all

  test "get root" do
    assert_routing "/", { :controller => "welcome", :action => "index" }
  end

  test "should render page controller" do
    assert_routing "impressum", { :controller => "pages", :action => "show", :page_name => "impressum" }
    assert_routing "unavailable", { :controller => "pages", :action => "show", :page_name => "unavailable" }
  end

  test "event resource available" do
    assert_routing "events/4", {:controller => "events", :action => "show", :id => "4" }
  end

end
