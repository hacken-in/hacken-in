# encoding: utf-8
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
    single = FactoryGirl.create(:single_event, topic: "A")
    assert_equal "A (SimpleEvent)", single.title
    assert_equal "A (SimpleEvent) am #{single.occurrence.strftime("%d.%m.%Y um %H:%M")}", single.name
  end

  test "should delete comment when singleevent is deleted" do
    single = FactoryGirl.create(:single_event, topic: "A")
    comment = single.comments.build(body: "wow!")
    comment.save
    single.destroy
    assert_equal 0, Comment.where(id: comment.id).count
  end

  test "should generate opengraph data" do
    single = FactoryGirl.create(:single_event)
    hash = {"og:description"=>"SimpleSingleEventTopic", "og:title"=>"SimpleSingleEventTopic (SimpleEvent) am #{single.occurrence.strftime("%d.%m.%Y um %H:%M")}"}
    assert_equal hash, single.to_opengraph

    single = FactoryGirl.create(:extended_single_event)
    hash = {"og:country-name"=>"Germany",
       "og:description"=>"SimpleSingleEventTopic - wow this is a description",
       "og:latitude"=>50.9490714,
       "og:locality"=>"CoWoCo, Gasmotorenfabrik, 3. Etage",
       "og:longitude"=>6.9868201,
       "og:postal-code"=>"51063",
       "og:street-address"=>"Deutz-Mülheimerstraße 129",
       "og:title"=>"SimpleSingleEventTopic (SimpleEvent) am #{single.occurrence.strftime("%d.%m.%Y um %H:%M")}"}
    assert_equal hash, single.to_opengraph
  end

end
