
$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '../..', 'test'))

require 'test_helper'
require 'ostruct'

class CalendarTest < ActiveSupport::TestCase

  test "should catalog events by day" do
    today, tomorrow = Date.new(2012, 10, 12), Date.new(2012, 10, 13)

    first  = OpenStruct.new(occurrence: today)
    second = OpenStruct.new(occurrence: tomorrow)
    third  = OpenStruct.new(occurrence: tomorrow)

    days = Calendar.events_by_day [second, first, third]

    expected = {
      today => [first],
      tomorrow => [second, third]
    }

    assert_equal expected, days
  end

  test "should fill up missing events and sort" do
    today, tomorrow, day_after_tomorrow = Date.new(2012, 10, 12), Date.new(2012, 10, 13), Date.new(2012, 10, 14)

    some_day = OpenStruct.new

    days = {
      day_after_tomorrow => [some_day, some_day],
      today => [some_day, some_day, some_day]
    }

    filled_and_sorted_days = Calendar.fill_gaps(days, today, day_after_tomorrow, 3)

    expected = [
      [today, [some_day, some_day, some_day]],
      [tomorrow, [nil, nil, nil]],
      [day_after_tomorrow, [some_day, some_day, nil]]
    ]

    assert_equal expected, filled_and_sorted_days
  end

end

