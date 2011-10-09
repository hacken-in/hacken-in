require 'test_helper'

class EventHelperTest < ActionView::TestCase
  include EventHelper

  def test_tag_list_for_taggable
    event = Event.new(name: "Hallo")
    event.save
    assert_equal "[]", tag_list_for_taggable(event)
    event.tag_list = "ruby, rails"
    assert_equal ["ruby", "rails"], event.tag_list
    assert_equal "[{\"name\":\"ruby\"},{\"name\":\"rails\"}]", tag_list_for_taggable(event)

    # nur um sicher zu gehen, noch mal mit neu laden probieren :)
    event.save
    event.reload
    
    assert_equal "[{\"name\":\"ruby\"},{\"name\":\"rails\"}]", tag_list_for_taggable(event)
 end

end
