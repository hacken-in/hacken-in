# encoding: utf-8
require 'test_helper'

class EventTest < ActiveSupport::TestCase

  test "can be saved" do
    
    test_date = 7.days.from_now
    
    event = Event.new(name: "Hallo")
    assert_equal 0, event.schedule.all_occurrences.size
    event.schedule.add_recurrence_time(test_date)
    assert_equal 1, event.schedule.all_occurrences.size
    assert event.save

    event = Event.find_by_id(event.id)
    assert_equal 1, event.schedule.all_occurrences.size
    assert_equal test_date.to_date, event.schedule.all_occurrences.first.to_date

    event = Event.new(name: "Hallo")
    event.schedule_yaml = "--- \n:start_date: #{test_date}\n:rrules: []\n\n:exrules: []\n\n:rdates: \n- #{test_date}\n:exdates: []\n\n:duration: \n:end_time: \n"
    
    assert_equal 1, event.schedule.all_occurrences.size
    assert_equal test_date.to_date, event.schedule.all_occurrences.first.to_date

    event = Event.new(name: "Hallo")
    schedule = IceCube::Schedule.new(1.year.ago)
    schedule.add_recurrence_time(7.days.from_now)
    event.schedule = schedule
    assert_equal 1, event.schedule.all_occurrences.size
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

  test "check if adress is not geocoded if no adress is given" do
    event = Event.new(name: "Hallo")
    event.latitude = 1.23132
    event.longitude = 1.22344
    event.save
    assert_nil event.latitude
    assert_nil event.longitude
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
    assert_equal ["ruby", "rails"], event.tag_list

    event.tag_list << "jquery"
    assert_equal  ["ruby", "rails", "jquery"], event.tag_list
    event.save
    event.reload
    assert_equal ["ruby", "rails", "jquery"], event.tags.map {|e| e.name}
  end

  test "generate single events for a new event" do
    event = FactoryGirl.create(:simple)
    event.schedule.add_recurrence_rule IceCube::Rule.weekly.day(:thursday)
    assert_difference 'SingleEvent.count', 12 do
      event.save
    end
  end

  test "generate single events if pattern changed" do
    event = FactoryGirl.create(:simple)
    event.schedule.add_recurrence_rule IceCube::Rule.weekly.day(:thursday)
    event.save
    #    existing single events should be removed
    event.schedule.remove_recurrence_rule IceCube::Rule.weekly.day(:thursday)
    assert_difference "SingleEvent.count", -12 do
      event.save
    end
  end

  test "no single_event regeneration if schedule not changed" do
    event = FactoryGirl.create(:simple)
    event.schedule.add_recurrence_rule IceCube::Rule.weekly.day(:thursday)
    event.save

    old_single_events = event.single_events.map{|e| e.id}

    event.description = "new desc"
    event.save

    se = event.single_events.to_a

    assert_equal 12, se.length
    assert_equal old_single_events, event.single_events.map{|e| e.id}
  end

  test "future_single_event_creation" do
    event = FactoryGirl.create(:simple)
    event.schedule.add_recurrence_rule IceCube::Rule.weekly.day(:thursday)
    assert_difference "SingleEvent.count", 12 do
      event.future_single_event_creation
    end
  end

  test "future_single_events_cleanup" do
    event = FactoryGirl.create(:simple)
    event.schedule.add_recurrence_rule IceCube::Rule.weekly.day(:monday)
    event.save
    first_single_event_id = event.single_events.first.id

    event.schedule.remove_recurrence_rule IceCube::Rule.weekly.day(:monday)
    assert_difference "SingleEvent.count", -12 do
      event.future_single_events_cleanup
    end

    assert !SingleEvent.exists?(first_single_event_id), "SingleEvent with id=#{first_single_event_id} should be deleted by cleanup."
  end

  test "don't remove single events that match the rules" do
    event = FactoryGirl.create(:simple)
    event.schedule.add_recurrence_rule IceCube::Rule.weekly.day(:thursday)
    event.save

    single_event_ids = event.single_events.map {|e| e.id}

    event.future_single_events_cleanup

    assert_equal single_event_ids, event.single_events.map {|e| e.id}
  end

  test "should get single events ordered" do
    event = FactoryGirl.create(:simple)

    first = (Time.now + 2.days).localtime
    second = (Time.now + 5.days).localtime

    SingleEvent.create(event: event, occurrence: second)
    SingleEvent.create(event: event, occurrence: first)

    assert_equal 2, event.single_events.count
    assert_equal first, event.single_events[0].occurrence
    assert_equal second, event.single_events[1].occurrence
  end

  test "should get title" do
    event = FactoryGirl.create(:simple)
    assert_equal "SimpleEvent", event.title
  end

  test "should delete comment when event is deleted" do
    event = FactoryGirl.create(:simple)
    comment = event.comments.build(body: "wow!")
    comment.save
    event.destroy
    assert_equal 0, Comment.where(id: comment.id).count
  end

  test "should generate opengraph data" do
    event = FactoryGirl.create(:simple)
    hash = {"og:title"=>"SimpleEvent"}
    assert_equal hash, event.to_opengraph

    event = FactoryGirl.create(:full_event)
    hash = {"og:country-name"=>"Germany",
       "og:locality"=>"CoWoCo, Gasmotorenfabrik, 3. Etage",
       "og:postal-code"=>"51063",
       "og:street-address"=>"Deutz-Mülheimerstraße 129",
       "og:title"=>"SimpleEvent",
       "og:description" => "Dragée bonbon tootsie roll icing jelly sesame snaps croissant apple pie. Suga..."}

    event_opengraph = event.to_opengraph
    hash.each_pair {|key, value| assert_equal event_opengraph[key], value}

    # The coordinates change, therefore we only check a few digits:
    assert_equal event_opengraph["og:latitude"].to_s[0,5], "50.94"
    assert_equal event_opengraph["og:longitude"].to_s[0,4], "6.98"
  end

  test "do not delete single events that are not based_on_rule" do
    event = FactoryGirl.create(:simple)
    event.schedule.add_recurrence_rule IceCube::Rule.weekly.day(:thursday)
    event.save

    event.single_events.create(topic: "test topic")

    #    existing single events should be removed
    event.schedule.remove_recurrence_rule IceCube::Rule.weekly.day(:thursday)
    assert_difference "SingleEvent.count", -12 do
      event.save
    end
    assert_equal 1, event.single_events.count
  end

  test "check ice_cube abstraction" do
    event = FactoryGirl.create(:simple)
    event.duration = 60
    event.save
    assert_equal 60 * 60, event.schedule.duration
  end

  test "if single event is deleted, add a exception rule and don't recreate it - bug #83" do
    event = FactoryGirl.create(:simple)
    event.schedule.add_recurrence_rule IceCube::Rule.weekly.day(:thursday)
    assert_difference 'SingleEvent.count', 12 do
      event.save
    end

    assert_equal 12, event.single_events.count
    event.single_events.first.destroy
    event.reload
    assert_equal 11, event.single_events.count
  end

end
