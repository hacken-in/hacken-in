# encoding: utf-8
require 'test_helper'

class EventTest < ActiveSupport::TestCase

  test "can be saved" do
    event = Event.new(name: "Hallo")
    assert_equal 0, event.schedule.all_occurrences.size
    event.schedule.add_recurrence_date(Time.new(2011,6,13,14,20,0,0))
    assert_equal 1, event.schedule.all_occurrences.size
    assert event.save

    event = Event.find_by_id(event.id)
    assert_equal 1, event.schedule.all_occurrences.size
    assert_equal Time.new(2011,6,13,14,20,0,0), event.schedule.all_occurrences.first

    event = Event.new(name: "Hallo")
    event.schedule_yaml = "--- \n:start_date: 2011-06-13 14:20:22 +02:00\n:rrules: []\n\n:exrules: []\n\n:rdates: \n- 2011-06-13 14:20:22 +02:00\n:exdates: []\n\n:duration: \n:end_time: \n"
    assert_equal 1, event.schedule.all_occurrences.size
    assert_equal Time.new(2011,6,13,14,20,22,"+02:00"), event.schedule.all_occurrences.first

    event = Event.new(name: "Hallo")
    schedule = IceCube::Schedule.new(Time.new(2011,6,14,19,30))
    schedule.add_recurrence_date(Time.new(2011,6,13,14,20,0,0))
    event.schedule = schedule
    assert_equal 1, event.schedule.all_occurrences.size
  end

  test "find events in range" do
    event = Event.new(name: "Hallo")
    event.schedule.add_recurrence_date(Time.new(2011,6,13,14,20,0,0))
    assert event.save
    event = Event.new(name: "Hallo")
    event.schedule.add_recurrence_date(Time.new(2010,6,13,14,20,0,0))
    assert event.save
    event = Event.new(name: "Hallo")
    event.schedule.add_recurrence_date(Time.new(2011,6,15,14,20,0,0))
    assert event.save
    event = Event.new(name: "Hallo")
    event.schedule.add_recurrence_date(Time.new(2011,7,15,14,20,0,0))
    assert event.save

    assert_equal 2, Event.find_in_range(Date.new(2011,6,1), Date.new(2011,7,1)).size
  end

  test "get ordered list" do
    event = Event.new(name: "Hallo")
    event.schedule.add_recurrence_date(Time.new(2011,6,13,14,20,0,0))
    assert event.save
    event = Event.new(name: "Hallo")
    event.schedule.add_recurrence_date(Time.new(2010,6,13,14,20,0,0))
    assert event.save
    event = Event.new(name: "Hallo")
    event.schedule.add_recurrence_date(Time.new(2011,6,15,14,20,0,0))
    assert event.save
    event = Event.new(name: "Hallo")
    event.schedule.add_recurrence_date(Time.new(2011,7,15,14,20,0,0))
    assert event.save
    event = Event.new(name: "Hallo", full_day: true)
    event.schedule.add_recurrence_date(Time.new(2011,6,13,18,20,0,0))
    assert event.save

    ordered = Event.get_ordered_events(Date.new(2011,6,1), Date.new(2011,7,1))
    assert_equal 3, ordered.size
    assert_equal Time.new(2011,6,13,0,0,0,"+02:00"),   ordered[0][:time]
    assert_equal Time.new(2011,6,13,16,20,0,"+02:00"), ordered[1][:time]
    assert_equal Time.new(2011,6,15,16,20,0,"+02:00"), ordered[2][:time]
  end

  test "check if adress is geocoded after save" do
    event = Event.new(name: "Hallo")
    event.location = "Cowoco in der Gasmotorenfabrik, 3. Etage"
    event.street = "Deutz-Mülheimerstraße 129"
    event.city = "Köln"
    event.zipcode = "51063"
    event.save

    assert_not_nil event.latitude
    assert_not_nil event.longitude
  end

  test "event adress formatting" do
    event = Event.new(name: "Hallo")
    event.location = "Cowoco in der Gasmotorenfabrik, 3. Etage"
    event.street = "Deutz-Mülheimerstraße 129"
    event.city = "Köln"
    event.zipcode = "51063"
    assert_equal "Deutz-Mülheimerstraße 129, 51063 Köln", event.address

    event = Event.new(name: "Hallo")
    event.street = "Deutz-Mülheimerstraße 129"
    event.city = "Köln"
    assert_equal "Deutz-Mülheimerstraße 129, Köln", event.address

    event = Event.new(name: "Hallo")
    event.street = "Deutz-Mülheimerstraße 129"
    assert_equal "Deutz-Mülheimerstraße 129", event.address

    event = Event.new(name: "Hallo")
    event.city = "Köln"
    event.zipcode = "51063"
    assert_equal "51063 Köln", event.address
  end
  
  test "tagging" do
    event = Event.new(name: "Hallo") 
    assert_equal 0, event.tags.count
    
    event.tag_list = "ruby, rails"
    assert_equal event.tag_list, ["ruby", "rails"]
    
    event.tag_list << "jquery"
    assert_equal event.tag_list, ["ruby", "rails", "jquery"]
  end

  test "generate single events for a new event" do
    event = Event.new(name: "Hallo")

    event.schedule.add_recurrence_rule IceCube::Rule.weekly.day(:thursday)

    event.save
    assert_difference 'SingleEvent.count', 12 do
      event.generate_single_events
    end
  end

  test "generate single events if pattern changed" do
    event = Event.new(name: "Hallo")

    event.schedule.add_recurrence_rule IceCube::Rule.weekly.day(:thursday)

    event.save
    event.generate_single_events

    event.schedule.remove_recurrence_rule IceCube::Rule.weekly.day(:thursday)

    event.save

    assert_difference "SingleEvent.count", -12 do
      event.generate_single_events
    end

  end

end
