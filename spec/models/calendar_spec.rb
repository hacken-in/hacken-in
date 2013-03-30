require "spec_helper"

describe Calendar do
  let(:today) { Date.new(2012, 10, 12) }
  let(:tomorrow) { Date.new(2012, 10, 13) }
  let(:day_after_tomorrow) { Date.new(2012, 10, 14) }

  it "should catalog events by day" do
    first  = OpenStruct.new(occurrence: today)
    second = OpenStruct.new(occurrence: tomorrow)
    third  = OpenStruct.new(occurrence: tomorrow)

    days = Calendar.events_by_day [second, first, third]

    expected = {
      today => [first],
      tomorrow => [second, third]
    }

    days.should eq expected
  end

  it "should fill up missing events and sort" do
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

    filled_and_sorted_days.should eq expected
  end
end
