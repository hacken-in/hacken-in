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

  test "should sort events via date if they are not on the same day" do
    time_now = Time.now
    event_beginning_in_one_day = FactoryGirl.create(:single_event, :occurrence => (time_now + 1.day), :topic => "A")
    event_beginning_in_one_day.event.full_day = false
    event_beginning_in_one_day.event.save

    event_beginning_now = FactoryGirl.create(:single_event, :occurrence => time_now, :topic => "A")
    event_beginning_now.event.full_day = false
    event_beginning_now.event.save

    sorted_collection = [event_beginning_in_one_day, event_beginning_now].sort
    assert_equal sorted_collection.first, event_beginning_now
    assert_equal sorted_collection.second, event_beginning_in_one_day
  end

  test "should prefer all-day events when sorting" do
    time_now = Time.now
    all_day_event = FactoryGirl.create(:single_event, :occurrence => time_now, :topic => "A")
    all_day_event.event.full_day = true
    all_day_event.event.save

    not_all_day_event = FactoryGirl.create(:single_event, :occurrence => time_now, :topic => "A")
    not_all_day_event.event.full_day = false
    not_all_day_event.event.save

    sorted_collection = [not_all_day_event, all_day_event].sort
    assert_equal sorted_collection.first, all_day_event
    assert_equal sorted_collection.second, not_all_day_event
  end

  test "should sort via title when both are all-day events" do
    time_now = Time.now
    event_beginning_with_a = FactoryGirl.create(:single_event, :occurrence => time_now, :topic => "A")
    event_beginning_with_a.event.full_day = true
    event_beginning_with_a.event.save

    event_beginning_with_b = FactoryGirl.create(:single_event, :occurrence => time_now, :topic => "B")
    event_beginning_with_b.event.full_day = true
    event_beginning_with_b.event.save

    sorted_collection = [event_beginning_with_b, event_beginning_with_a].sort
    assert_equal sorted_collection.first, event_beginning_with_a
    assert_equal sorted_collection.second, event_beginning_with_b
  end

  test "should sort via time when both are not full day" do
    time_now = Time.now
    event_beginning_in_one_hour = FactoryGirl.create(:single_event, :occurrence => (time_now + 1.hour), :topic => "A")
    event_beginning_in_one_hour.event.full_day = false
    event_beginning_in_one_hour.event.save

    event_beginning_now = FactoryGirl.create(:single_event, :occurrence => time_now, :topic => "A")
    event_beginning_now.event.full_day = false
    event_beginning_now.event.save

    sorted_collection = [event_beginning_in_one_hour, event_beginning_now].sort
    assert_equal sorted_collection.first, event_beginning_now
    assert_equal sorted_collection.second, event_beginning_in_one_hour
  end

  test "should sort via title when both are at the same time" do
    time_now = Time.now
    event_beginning_with_a = FactoryGirl.create(:single_event, :occurrence => time_now, :topic => "A")
    event_beginning_with_a.event.full_day = false
    event_beginning_with_a.event.save

    event_beginning_with_b = FactoryGirl.create(:single_event, :occurrence => time_now, :topic => "B")
    event_beginning_with_b.event.full_day = false
    event_beginning_with_b.event.save

    sorted_collection = [event_beginning_with_b, event_beginning_with_a].sort
    assert_equal sorted_collection.first, event_beginning_with_a
    assert_equal sorted_collection.second, event_beginning_with_b
  end

  test "should generate title and name" do
    single = FactoryGirl.create(:single_event, :occurrence => Time.new(2011, 10, 1, 12, 0, 0).localtime, :topic => "A")
    assert_equal "A (SimpleEvent)", single.title
    assert_equal "A (SimpleEvent) am 01.10.2011 um 12:00", single.name
  end
end
