require 'test_helper'

class EventTest < ActiveSupport::TestCase

  test "can be saved" do
    event = Event.new
    assert_equal 0, event.schedule.all_occurrences.size
    event.schedule.add_recurrence_date(Time.new(2011,6,13,14,20,0,0))
    assert_equal 1, event.schedule.all_occurrences.size
    event.save

    event = Event.find_by_id(event.id)
    assert_equal 1, event.schedule.all_occurrences.size
    assert_equal Time.new(2011,6,13,14,20,0,0), event.schedule.all_occurrences.first

    event = Event.new
    event.schedule_yaml = "--- \n:start_date: 2011-06-13 14:20:22 +02:00\n:rrules: []\n\n:exrules: []\n\n:rdates: \n- 2011-06-13 14:20:22 +02:00\n:exdates: []\n\n:duration: \n:end_time: \n"
    assert_equal 1, event.schedule.all_occurrences.size
    assert_equal Time.new(2011,6,13,14,20,22,"+02:00"), event.schedule.all_occurrences.first
  end

  test "find events in range" do
    event = Event.new
    event.schedule.add_recurrence_date(Time.new(2011,6,13,14,20,0,0))
    event.save
    event = Event.new
    event.schedule.add_recurrence_date(Time.new(2010,6,13,14,20,0,0))
    event.save
    event = Event.new
    event.schedule.add_recurrence_date(Time.new(2011,6,15,14,20,0,0))
    event.save
    event = Event.new
    event.schedule.add_recurrence_date(Time.new(2011,7,15,14,20,0,0))
    event.save

    assert_equal 2, Event.find_in_range(Date.new(2011,6,1), Date.new(2011,7,1)).size
  end

end
