# encoding: utf-8
require 'test_helper'

class EventTest < ActiveSupport::TestCase

  test "validate presence of name" do
    event = Event.new name: 'event'
    assert event.valid?

    event_without_name = Event.new
    assert_equal false, event_without_name.valid?
  end

  test "can be saved" do
    test_date = 7.days.from_now
    test_date += 2.hours if test_date.hour < 2

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

    # Always pick 1st March of next year, 15:15pm
    # This prevents us from falling into IceCube bug pitfalls
    today = DateTime.new(Time.now.year + 1, 3, 1, 15, 15)

    first = today + 2.days + (today.hour < 2 ? 2.hours : 0)
    second = today + 5.days + (today.hour < 2 ? 2.hours : 0)

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
    hash = {
      "og:country-name"=>"DE",
      "og:latitude"=>50.9490279,
      "og:locality"=>"CoWoCo, Gasmotorenfabrik, 3. Etage",
      "og:longitude"=>6.986784900000001,
      "og:postal-code"=>"51063",
      "og:street-address"=>"Deutz-Mülheimerstraße 129",
      "og:title"=>"SimpleEvent"}
    assert_equal hash, event.to_opengraph

    event = FactoryGirl.create(:full_event)
    hash = {
       "og:country-name"=>"DE",
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

    event.single_events.create(name: "test name")

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

  test "simplify exdates" do
    event = FactoryGirl.create(:simple)
    event.schedule.add_recurrence_rule IceCube::Rule.weekly.day(:thursday)
    exclude = event.schedule.first
    event.schedule.add_exception_time exclude
    assert_equal [exclude], event.excluded_times
  end

  test "update exdates" do
    event = FactoryGirl.create(:simple)
    event.schedule.add_recurrence_rule IceCube::Rule.weekly.day(:thursday)
    exclude = event.schedule.first
    event.excluded_times = [exclude]
    assert_equal [exclude], event.excluded_times
  end

  test "simplify rrules" do
    event = FactoryGirl.create(:simple)
    event.schedule.add_recurrence_rule IceCube::Rule.monthly.day_of_week({1 => [-1]})
    assert_equal [{"type" => 'monthly', "interval" => -1, "days" => ["monday"]}], event.schedule_rules
  end

  test "update rrules" do
    event = FactoryGirl.create(:simple)
    time = Time.new(2012, 10, 10, 20, 15, 0)
    event.start_time = time
    event.schedule_rules = [{"type" => 'monthly', "interval" => -1, "days" => ["monday"]}]
    event.save
    # ToDo: wait till this is fixed in ice_cube
    # hopefully it has no real issues in our system, only
    # in the weird time setup on the travis systems
    #
    # https://github.com/seejohnrun/ice_cube/issues/115
    assert_equal 1, event.single_events.first.occurrence.wday
    # assert_equal time.hour, event.single_events.first.occurrence.hour
    assert_equal time.min, event.single_events.first.occurrence.min
  end

end
