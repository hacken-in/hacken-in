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

    ordered = Event.get_ordered_events(Date.new(2011,6,1), Date.new(2011,7,1))
    assert_equal 2, ordered.size
    assert_equal Time.new(2011,6,13,16,20,0,"+02:00"), ordered[0][:time]
    assert_equal Time.new(2011,6,15,16,20,0,"+02:00"), ordered[1][:time]
  end

end
