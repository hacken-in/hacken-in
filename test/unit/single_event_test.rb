# encoding: utf-8
require 'test_helper'

class SingleEventTest < ActiveSupport::TestCase
  test "create or find" do
    single_event = FactoryGirl.create(:single_event)
    assert_equal single_event, SingleEvent.where(event_id: single_event.event.id, occurrence: single_event.occurrence).first_or_create
  end

  test "scope single events in the future" do
    event = FactoryGirl.create(:simple)

    assert_difference "SingleEvent.in_future.count", +1 do
      SingleEvent.create(occurrence: 1.day.from_now, event: event)
    end

    assert_difference "SingleEvent.in_future.count", 0 do
      SingleEvent.create(occurrence: 1.day.ago, event: event)
    end
  end

  test "should generate title based on name" do
    assert_equal "SimpleEvent (SimpleSingleEventName)", FactoryGirl.create(:single_event).title
    assert_equal "SimpleEvent", FactoryGirl.create(:single_event_without_name).title
  end

  test "should sort events via date if they are not on the same day" do
    time_now = Time.now
    event_beginning_in_one_day = FactoryGirl.create(:single_event, occurrence: (time_now + 1.day), name: "A")
    event_beginning_in_one_day.event.full_day = false
    event_beginning_in_one_day.event.save

    event_beginning_now = FactoryGirl.create(:single_event, occurrence: time_now, name: "A")
    event_beginning_now.event.full_day = false
    event_beginning_now.event.save

    sorted_collection = [event_beginning_in_one_day, event_beginning_now].sort
    assert_equal sorted_collection.first, event_beginning_now
    assert_equal sorted_collection.second, event_beginning_in_one_day
  end

  test "should prefer all-day events when sorting" do
    time_now = Time.now
    all_day_event = FactoryGirl.create(:single_event, occurrence: time_now, name: "A")
    all_day_event.event.full_day = true
    all_day_event.event.save

    not_all_day_event = FactoryGirl.create(:single_event, occurrence: time_now, name: "A")
    not_all_day_event.event.full_day = false
    not_all_day_event.event.save

    sorted_collection = [not_all_day_event, all_day_event].sort
    assert_equal sorted_collection.first, all_day_event
    assert_equal sorted_collection.second, not_all_day_event
  end

  test "should sort via title when both are all-day events" do
    time_now = Time.now
    event_beginning_with_a = FactoryGirl.create(:single_event, occurrence: time_now, name: "A")
    event_beginning_with_a.event.full_day = true
    event_beginning_with_a.event.save

    event_beginning_with_b = FactoryGirl.create(:single_event, occurrence: time_now, name: "B")
    event_beginning_with_b.event.full_day = true
    event_beginning_with_b.event.save

    sorted_collection = [event_beginning_with_b, event_beginning_with_a].sort
    assert_equal sorted_collection.first, event_beginning_with_a
    assert_equal sorted_collection.second, event_beginning_with_b
  end

  test "should sort via time when both are not full day" do
    time_now = Time.now
    event_beginning_in_one_hour = FactoryGirl.create(:single_event, occurrence: (time_now + 1.hour), name: "A")
    event_beginning_in_one_hour.event.full_day = false
    event_beginning_in_one_hour.event.save

    event_beginning_now = FactoryGirl.create(:single_event, occurrence: time_now, name: "A")
    event_beginning_now.event.full_day = false
    event_beginning_now.event.save

    sorted_collection = [event_beginning_in_one_hour, event_beginning_now].sort
    assert_equal sorted_collection.first, event_beginning_now
    assert_equal sorted_collection.second, event_beginning_in_one_hour
  end

  test "should sort via title when both are at the same time" do
    time_now = Time.now
    event_beginning_with_a = FactoryGirl.create(:single_event, occurrence: time_now, name: "A")
    event_beginning_with_a.event.full_day = false
    event_beginning_with_a.event.save

    event_beginning_with_b = FactoryGirl.create(:single_event, occurrence: time_now, name: "B")
    event_beginning_with_b.event.full_day = false
    event_beginning_with_b.event.save

    sorted_collection = [event_beginning_with_b, event_beginning_with_a].sort
    assert_equal sorted_collection.first, event_beginning_with_a
    assert_equal sorted_collection.second, event_beginning_with_b
  end

  test "should generate full name and name with date" do
    single = FactoryGirl.create(:single_event, name: "A")
    assert_equal "SimpleEvent (A)", single.full_name
    assert_equal "SimpleEvent (A) am #{single.occurrence.strftime("%d.%m.%Y um %H:%M")}", single.name_with_date
  end

  test "should delete comment when singleevent is deleted" do
    single = FactoryGirl.create(:single_event, name: "A")
    comment = single.comments.build(body: "wow!")
    comment.save
    single.destroy
    assert_equal 0, Comment.where(id: comment.id).count
  end

  test "should generate opengraph data" do
    single = FactoryGirl.create(:single_event)
    hash = {
      "og:country-name"=>"DE",
      "og:latitude"=>50.9490279,
      "og:locality"=>"CoWoCo, Gasmotorenfabrik, 3. Etage",
      "og:longitude"=>6.986784900000001,
      "og:postal-code"=>"51063",
      "og:street-address"=>"Deutz-Mülheimerstraße 129",
      "og:title"=>"SimpleEvent (SimpleSingleEventName) am #{single.occurrence.strftime("%d.%m.%Y um %H:%M")}"}
    assert_equal hash, single.to_opengraph

    single = FactoryGirl.create(:extended_single_event)
    hash = {
      "og:country-name"=>"DE",
      "og:description"=>"wow this is a description",
      "og:locality"=>"CoWoCo, Gasmotorenfabrik, 3. Etage",
      "og:postal-code"=>"51063",
      "og:street-address"=>"Deutz-Mülheimerstraße 129",
      "og:title"=>"SimpleEvent (SimpleSingleEventName) am #{single.occurrence.strftime("%d.%m.%Y um %H:%M")}"}

    single_event_opengraph = single.to_opengraph
    hash.each_pair {|key, value| assert_equal single_event_opengraph[key], value}

    # The coordinates change, therefore we only check a few digits:
    assert_equal single_event_opengraph["og:latitude"].to_s[0,5], "50.94"
    assert_equal single_event_opengraph["og:longitude"].to_s[0,4], "6.98"
  end

  test "user can participate on single event" do
    single = FactoryGirl.create(:single_event)
    user = FactoryGirl.create(:user)
    single.users << user
    single.save

    assert_equal user, single.users.first
    assert_equal 1, single.users.length
  end

  test "get data from event if not defined in model" do
    single = FactoryGirl.create(:single_event)
    user = FactoryGirl.create(:user)

    single.event.url = "http://www.example.com"
    single.event.full_day = true
    assert_equal "http://www.example.com", single.url
    assert single.full_day

    single.url = "http://www.example.com/single"
    single.full_day = false
    assert_equal "http://www.example.com/single", single.url
    assert !single.full_day

    single.url = ""
    single.full_day = nil
    assert_equal "http://www.example.com", single.url
    assert single.full_day
  end

  test "should get single event if by_tag is correct" do
    single = FactoryGirl.create(:single_event)
    single.tag_list << "meintag"
    single.save
    single2 = FactoryGirl.create(:single_event)
    single2.tag_list << "notmeintag"
    single2.save

    assert_equal [single], SingleEvent.only_tagged_with("meintag")
  end

  test "should get single event if event is tagged" do
    single = FactoryGirl.create(:single_event)
    single.event.tag_list << "meintag"
    single.event.save
    single2 = FactoryGirl.create(:single_event)
    single2.tag_list << "notmeintag"
    single2.save

    assert_equal [single], SingleEvent.only_tagged_with("meintag")
  end

  test "should generate ri_cal_event" do
    single = FactoryGirl.create(:single_event)
    ical = <<ical
BEGIN:VEVENT
DTEND;VALUE=DATE-TIME:#{(single.occurrence + single.duration * 60).utc.strftime("%Y%m%dT%H%M%SZ")}
DTSTART;VALUE=DATE-TIME:#{single.occurrence.utc.strftime("%Y%m%dT%H%M%SZ")}
DESCRIPTION:
URL:http://hcking.dev/events/1/dates/1
SUMMARY:SimpleEvent (SimpleSingleEventName)
LOCATION:Deutz-Mülheimerstraße 129\\, 51063 Köln
END:VEVENT
ical
    assert_equal ical.strip, single.to_ri_cal_event.to_s.strip
  end

  test "should add link to description in ri_cal_event" do
    single = FactoryGirl.create :single_event
    ical = <<ical
BEGIN:VEVENT
DTEND;VALUE=DATE-TIME:#{(single.occurrence + single.duration * 60).utc.strftime("%Y%m%dT%H%M%SZ")}
DTSTART;VALUE=DATE-TIME:#{single.occurrence.utc.strftime("%Y%m%dT%H%M%SZ")}
DESCRIPTION:http://hcking.dev/events/1/dates/1
SUMMARY:SimpleEvent (SimpleSingleEventName)
LOCATION:Deutz-Mülheimerstraße 129\\, 51063 Köln
END:VEVENT
ical
    assert_equal ical.strip, single.to_ri_cal_event(true).to_s.strip
  end
end
