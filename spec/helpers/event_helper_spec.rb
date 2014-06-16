require 'spec_helper'
require 'json'

describe EventHelper do
  include EventHelper

  it "should get list for taggable" do
    event = FactoryGirl.create(:simple)
    assert_equal "[]", tag_list_for_taggable(event)
    event.tag_list = "ruby, rails"
    expect(event.tag_list).to match_array(["ruby", "rails"])
    expect(JSON.load(tag_list_for_taggable(event))).to contain_exactly({"name" => "ruby"}, {"name" =>"rails"})

    # nur um sicher zu gehen, noch mal mit neu laden probieren :)
    event.save
    event.reload

    expect(tag_list_for_taggable(event)).to eq("[{\"name\":\"rails\"},{\"name\":\"ruby\"}]")
  end

end
