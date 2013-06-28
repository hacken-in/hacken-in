# encoding: utf-8
require 'spec_helper'

describe Event do
  it "should validate presence of name" do
    category = FactoryGirl.create(:a_category)
    event = Event.new name: 'event', category: category
    event.valid?.should be_true

    event_without_name = Event.new category: category
    event_without_name.valid?.should be_false
  end

  it "should be saved" do
    test_date = 7.days.from_now
    test_date += 2.hours if test_date.hour < 2

    category = FactoryGirl.create(:a_category)
    event = Event.new(name: "Hallo", category: category)
    assert_equal 0, event.schedule.all_occurrences.size
    event.schedule.add_recurrence_time(test_date)
    event.schedule.all_occurrences.size.should == 1
    event.save.should be_true

    event = Event.find_by_id(event.id)
    event.schedule.all_occurrences.size.should == 1
    event.schedule.all_occurrences.first.to_date.should == test_date.to_date

    event = Event.new(name: "Hallo", category: category)
    event.schedule_yaml = "--- \n:start_date: #{test_date}\n:rrules: []\n\n:exrules: []\n\n:rdates: \n- #{test_date}\n:exdates: []\n\n:duration: \n:end_time: \n"

    event.schedule.all_occurrences.size.should == 1

    event.schedule.all_occurrences.first.to_date.should == test_date.to_date

    event = Event.new(name: "Hallo", category: category)
    schedule = IceCube::Schedule.new(1.year.ago)
    schedule.add_recurrence_time(7.days.from_now)
    event.schedule = schedule
    event.schedule.all_occurrences.size.should == 1
  end

  it "should provide tagging" do
    category = FactoryGirl.create(:a_category)
    event = Event.new(name: "Hallo", category: category)
    event.tags.count.should == 0

    event.tag_list = "ruby, rails"
    event.tag_list.should == ["ruby", "rails"]

    event.tag_list << "jquery"
    event.tag_list.should == ["ruby", "rails", "jquery"]
    event.save
    event.reload
    event.tags.map {|e| e.name}.should == ["ruby", "rails", "jquery"]
  end

  it "should generate single events for a new event" do
    event = FactoryGirl.create(:simple)
    event.schedule.add_recurrence_rule IceCube::Rule.weekly.day(:thursday)
    expect { event.save }.to change { SingleEvent.count }.by 12
  end

  it "should generate single events if pattern changed" do
    event = FactoryGirl.create(:simple)
    event.schedule.add_recurrence_rule IceCube::Rule.weekly.day(:thursday)
    event.save
    #    existing single events should be removed
    event.schedule.remove_recurrence_rule IceCube::Rule.weekly.day(:thursday)
    expect { event.save }.to change { SingleEvent.count }.by(-12)
  end

  it "should not regenerate single_event if schedule hasn't changed" do
    event = FactoryGirl.create(:simple)
    event.schedule.add_recurrence_rule IceCube::Rule.weekly.day(:thursday)
    event.save

    old_single_events = event.single_events.map{|e| e.id}

    event.description = "new desc"
    event.save

    se = event.single_events.to_a

    se.length.should == 12
    event.single_events.map { |e| e.id }.should == old_single_events
  end

  it "should create future single events" do
    event = FactoryGirl.create(:simple)
    event.schedule.add_recurrence_rule IceCube::Rule.weekly.day(:thursday)
    expect { event.future_single_event_creation }.to change { SingleEvent.count}.by 12
  end

  it "should clean up future single events" do
    event = FactoryGirl.create(:simple)
    event.schedule.add_recurrence_rule IceCube::Rule.weekly.day(:monday)
    event.save
    first_single_event_id = event.single_events.first.id

    event.schedule.remove_recurrence_rule IceCube::Rule.weekly.day(:monday)
    expect { event.future_single_events_cleanup }.to change { SingleEvent.count }.by(-12)

    # "SingleEvent with id=#{first_single_event_id} should be deleted by cleanup."
    SingleEvent.exists?(first_single_event_id).should be_false
  end

  it "should not remove single events that match the rules" do
    event = FactoryGirl.create(:simple)
    event.schedule.add_recurrence_rule IceCube::Rule.weekly.day(:thursday)
    event.save

    single_event_ids = event.single_events.map {|e| e.id}

    event.future_single_events_cleanup

    event.single_events.map { |e| e.id }.should == single_event_ids
  end

  it "should get single events ordered" do
    event = FactoryGirl.create(:simple)

    # Always pick 1st March of next year, 15:15pm
    # This prevents us from falling into IceCube bug pitfalls
    today = DateTime.new(Time.now.year + 1, 3, 1, 15, 15)

    first = today + 2.days + (today.hour < 2 ? 2.hours : 0)
    second = today + 5.days + (today.hour < 2 ? 2.hours : 0)

    SingleEvent.create(event: event, occurrence: second)
    SingleEvent.create(event: event, occurrence: first)

    event.single_events.count.should == 2
    event.single_events[0].occurrence.should == first
    event.single_events[1].occurrence.should == second
  end

  it "should return the title" do
    event = FactoryGirl.create(:simple)
    event.title.should == "SimpleEvent"
  end

  it "should delete comment when it is deleted" do
    event = FactoryGirl.create(:simple)
    comment = event.comments.build(body: "wow!")
    comment.save
    event.destroy
    Comment.where(id: comment.id).count.should == 0
  end

  it "should generate opengraph data" do
    event = FactoryGirl.create(:simple)
    hash = {
      "og:country-name"=>"DE",
      "og:latitude"=>50.9490279,
      "og:locality"=>"CoWoCo, Gasmotorenfabrik, 3. Etage",
      "og:longitude"=>6.986784900000001,
      "og:postal-code"=>"51063",
      "og:street-address"=>"Deutz-Mülheimerstraße 129",
      "og:title"=>"SimpleEvent"}
    event.to_opengraph.should == hash

    event = FactoryGirl.create(:full_event)
    hash = {
       "og:country-name"=>"DE",
       "og:locality"=>"CoWoCo, Gasmotorenfabrik, 3. Etage",
       "og:postal-code"=>"51063",
       "og:street-address"=>"Deutz-Mülheimerstraße 129",
       "og:title"=>"SimpleEvent",
       "og:description" => "Dragée bonbon tootsie roll icing jelly sesame snaps croissant apple pie. Suga..."
    }

    event_opengraph = event.to_opengraph
    hash.each_pair {|key, value| assert_equal event_opengraph[key], value}

    # The coordinates change, therefore we only check a few digits:
    event_opengraph["og:latitude"].to_s[0,5].should == "50.94"
    event_opengraph["og:longitude"].to_s[0,4].should == "6.98"
  end

  it "should not delete single events that are not based_on_rule" do
    event = FactoryGirl.create(:simple)
    event.schedule.add_recurrence_rule IceCube::Rule.weekly.day(:thursday)
    event.save

    event.single_events.create(name: "test name")

    #    existing single events should be removed
    event.schedule.remove_recurrence_rule IceCube::Rule.weekly.day(:thursday)
    expect { event.save }.to change { SingleEvent.count }.by(-12)
    event.single_events.count.should == 1
  end

  it "should check ice_cube abstraction" do
    event = FactoryGirl.create(:simple)
    event.duration = 60
    event.save
    event.schedule.duration.should == 60 * 60
  end

  it "should add a exception rule and don't recreate it - bug #83 if single event is deleted" do
    event = FactoryGirl.create(:simple)
    event.schedule.add_recurrence_rule IceCube::Rule.weekly.day(:thursday)
    expect { event.save }.to change { SingleEvent.count }.by 12

    event.single_events.count.should == 12
    event.single_events.first.destroy
    event.reload
    event.single_events.count.should == 11
  end

  it "should simplify exdates" do
    event = FactoryGirl.create(:simple)
    event.schedule.add_recurrence_rule IceCube::Rule.weekly.day(:thursday)
    exclude = event.schedule.first
    event.schedule.add_exception_time exclude
    event.excluded_times.should == [exclude]
  end

  it "should update exdates" do
    event = FactoryGirl.create(:simple)
    event.schedule.add_recurrence_rule IceCube::Rule.weekly.day(:thursday)
    exclude = event.schedule.first
    event.excluded_times = [exclude]
    event.excluded_times.should == [exclude]
  end

  it "should simplify rrules" do
    event = FactoryGirl.create(:simple)
    event.schedule.add_recurrence_rule IceCube::Rule.monthly.day_of_week({1 => [-1]})
    event.schedule_rules.should == [{"type" => 'monthly', "interval" => -1, "days" => ["monday"]}]
  end

  it "should update rules" do
    event = FactoryGirl.create(:simple)
    time = Time.new(2012, 10, 10, 20, 15, 0)
    event.start_time = time
    event.schedule_rules = [{"type" => 'monthly', "interval" => -1, "days" => ["monday"]}]
    event.save
    # TODO: wait till this is fixed in ice_cube
    # hopefully it has no real issues in our system, only
    # in the weird time setup on the travis systems
    #
    # https://github.com/seejohnrun/ice_cube/issues/115
    event.single_events.first.occurrence.wday.should == 1
    #event.single_events.first.occurrence.hour.should == time.hour
    event.single_events.first.occurrence.min.should == time.min
  end

  it "should find a coming-up single event as the closest one" do
    today      = Date.new(2012, 2, 2)
    tomorrow   = Date.new(2012, 2, 3)
    future     = Date.new(2012, 12, 1)
    way_before = Date.new(2011, 8, 2)

    single_event_tomorrow = OpenStruct.new(:occurrence => tomorrow)

    single_events = [OpenStruct.new(:occurrence => way_before),
                     single_event_tomorrow,
                     OpenStruct.new(:occurrence => future)]

    event = Event.new
    event.stub(:single_events) { single_events }

    event.closest_single_event(today).should == single_event_tomorrow
  end

  it "should find most recent single event as closest one" do
    today = Date.new(2012, 2, 2)
    yesterday = Date.new(2012, 2, 1)

    single_events = [OpenStruct.new(:occurrence => yesterday)]
    event = Event.new
    event.stub(:single_events) { single_events }

    event.closest_single_event(today).should == single_events.first
  end

  it "should return nil if there is no closest single event" do
    single_events = []

    event = Event.new
    event.stub(:single_events) { single_events }

    event.closest_single_event.should be_nil
  end

  it "should assign users as curators" do
    event = FactoryGirl.create(:simple)
    user = FactoryGirl.create(:user)

    event.curators << user

    user.curated_events.should =~ [event]
  end
end
