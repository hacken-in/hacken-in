require 'spec_helper'

describe EventHelper do
  include EventHelper

  it "should get list for taggable" do
    event = FactoryGirl.create(:simple)
    assert_equal "[]", tag_list_for_taggable(event)
    event.tag_list = "ruby, rails"
    event.tag_list.should == ["ruby", "rails"]
    tag_list_for_taggable(event).should == "[{\"name\":\"ruby\"},{\"name\":\"rails\"}]"

    # nur um sicher zu gehen, noch mal mit neu laden probieren :)
    event.save
    event.reload

    tag_list_for_taggable(event).should == "[{\"name\":\"ruby\"},{\"name\":\"rails\"}]"
  end

end
