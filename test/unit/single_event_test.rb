require 'test_helper'

class SingleEventTest < ActiveSupport::TestCase
  test "create or find" do
    single_event = FactoryGirl.create(:single_event)
    assert_equal single_event, SingleEvent.find_or_create(:event_id => single_event.event.id, :occurrence => single_event.occurrence)
  end

  test "scope single events in the future" do
    assert_difference "SingleEvent.in_future.count", +1 do
      event_tomorrow = SingleEvent.create(:occurrence => 1.day.from_now)
    end

    assert_difference "SingleEvent.in_future.count", 0 do
      event_yesterday = SingleEvent.create(:occurrence => 1.day.ago)
    end
  end

  test "should generate title based on topic" do
    assert_equal "SimpleSingleEventTopic (SimpleEvent)", FactoryGirl.create(:single_event).title
    assert_equal "SimpleEvent", FactoryGirl.create(:single_event_without_topic).title
  end
end
