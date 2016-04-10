# encoding: utf-8
require 'spec_helper'

describe Event do
  it "should validate presence of name" do
    category = FactoryGirl.create(:a_category)
    event = Event.new name: 'event', category: category
    expect(event.valid?).to be_truthy

    event_without_name = Event.new category: category
    expect(event_without_name.valid?).to be_falsey
  end

  it "should be saved" do
    test_date = 7.days.from_now
    test_date += 2.hours if test_date.hour < 2

    category = FactoryGirl.create(:a_category)
    event = Event.new(name: "Hallo", category: category)
    assert_equal 1, event.schedule.all_occurrences.size
    event.schedule.start_time = test_date
    event.schedule.add_recurrence_time(test_date)
    expect(event.schedule.all_occurrences.size).to eq(1)
    event.duration = 50
    expect(event.save).to be_truthy

    event = Event.find_by_id(event.id)
    expect(event.schedule.all_occurrences.size).to eq(1)
    expect(event.schedule.all_occurrences.first.to_date).to eq(test_date.to_date)

    event = Event.new(name: "Hallo", category: category)
    event.schedule_yaml = "--- \n:start_date: #{test_date.iso8601}\n:rrules: []\n\n:exrules: []\n\n:rdates: \n- #{test_date.iso8601}\n:exdates: []\n\n:duration: \n:end_time: \n"

    expect(event.schedule.all_occurrences.size).to eq(1)

    expect(event.schedule.all_occurrences.first.to_date).to eq(test_date.to_date)

    event = Event.new(name: "Hallo", category: category)
    schedule = IceCube::Schedule.new(1.year.ago)
    schedule.add_recurrence_time(7.days.from_now)
    event.schedule = schedule
    # A start date not on the first occurrence counts as an occurrence of its own
    expect(event.schedule.all_occurrences.size).to eq(2)
  end

  it "should provide tagging" do
    category = FactoryGirl.create(:a_category)
    event = Event.new(name: "Hallo", category: category)
    expect(event.tags.count).to eq(0)

    event.tag_list = "ruby, rails"
    expect(event.tag_list).to match_array(["ruby", "rails"])

    event.tag_list << "jquery"
    expect(event.tag_list).to match_array(["ruby", "rails", "jquery"])
    event.save
    event.reload
    expect(event.tags.pluck(:name)).to match_array(["jquery", "rails", "ruby"])
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

  it "should generate single events if pattern changed" do
    event = Event.new(name: "test")
    event.start_time = Time.now
    event.schedule_rules = [
        {"type" => 'weekly', "interval" => 2, "days" => ["monday"]}
    ]
    event.category = FactoryGirl.create(:a_category)
    event.save
    expect { event.save }.not_to change { SingleEvent.count }
  end

  it "should not regenerate single_event if schedule hasn't changed" do
    event = FactoryGirl.create(:simple)
    event.schedule.add_recurrence_rule IceCube::Rule.weekly.day(:thursday)
    event.save

    old_single_events = event.single_events.map {|e| e.id}

    event.description = "new desc"
    event.save

    se = event.single_events.to_a

    expect(se.length).to eq(12)
    expect(event.single_events.map {|e| e.id}).to eq(old_single_events)
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
    expect(SingleEvent.exists?(first_single_event_id)).to be_falsey
  end

  it "should not remove single events that match the rules" do
    event = FactoryGirl.create(:simple)
    event.schedule.add_recurrence_rule IceCube::Rule.weekly.day(:thursday)
    event.save

    single_event_ids = event.single_events.map {|e| e.id}

    event.future_single_events_cleanup

    expect(event.single_events.map {|e| e.id}).to eq(single_event_ids)
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

    expect(event.single_events.count).to eq(2)
    expect(event.single_events[0].occurrence).to eq(first)
    expect(event.single_events[1].occurrence).to eq(second)
  end

  it "should return the title" do
    event = FactoryGirl.create(:simple)
    expect(event.title).to eq("SimpleEvent")
  end

  it "should delete comment when it is deleted" do
    event = FactoryGirl.create(:simple)
    comment = event.comments.build(body: "wow!")
    comment.save
    event.destroy
    expect(Comment.where(id: comment.id).count).to eq(0)
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
    expect(event.to_opengraph).to eq(hash)

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
    expect(event_opengraph["og:latitude"].to_s[0,5]).to eq("50.94")
    expect(event_opengraph["og:longitude"].to_s[0,4]).to eq("6.98")
  end

  it "should not delete single events that are not based_on_rule" do
    event = FactoryGirl.create(:simple)
    event.schedule.add_recurrence_rule IceCube::Rule.weekly.day(:thursday)
    event.save

    event.single_events.create(name: "test name")

    #    existing single events should be removed
    event.schedule.remove_recurrence_rule IceCube::Rule.weekly.day(:thursday)
    expect { event.save }.to change { SingleEvent.count }.by(-12)
    expect(event.single_events.count).to eq(1)
  end

  it "should check ice_cube abstraction" do
    event = FactoryGirl.create(:simple)
    event.duration = 60
    event.save
    expect(event.schedule.duration).to eq(60 * 60)
  end

  it "should add a exception rule and don't recreate it - bug #83 if single event is deleted" do
    event = FactoryGirl.create(:simple)
    event.schedule.add_recurrence_rule IceCube::Rule.weekly.day(:thursday)
    expect { event.save }.to change { SingleEvent.count }.by 12

    expect(event.single_events.count).to eq(12)
    deleted_event = event.single_events.first.destroy
    event.reload
    # There's still 12 events as we always reify 12 future events
    expect(event.single_events.count).to eq(12)
    # Make sure the previous first single_event has been properly removed from the schedule
    expect(event.single_events.first.occurrence).not_to eq(deleted_event.occurrence)
  end

  it "should simplify exdates" do
    event = FactoryGirl.create(:simple)
    event.schedule.add_recurrence_rule IceCube::Rule.weekly.day(:thursday)
    exclude = event.schedule.first
    event.schedule.add_exception_time exclude
    expect(event.excluded_times).to eq([exclude])
  end

  it "should update exdates" do
    event = FactoryGirl.create(:simple)
    event.schedule.add_recurrence_rule IceCube::Rule.weekly.day(:thursday)
    exclude = event.schedule.first
    event.excluded_times = [exclude]
    expect(event.excluded_times).to eq([exclude])
  end

  it "should simplify rrules" do
    event = FactoryGirl.create(:simple)
    event.schedule.add_recurrence_rule IceCube::Rule.monthly.day_of_week({1 => [-1]})
    expect(event.schedule_rules).to eq([{"type" => 'monthly', "interval" => -1, "days" => ["monday"]}])
  end

  it "should update rules" do
    event = FactoryGirl.create(:simple)
    time = Time.utc(2012, 10, 10, 20, 15, 0)
    event.start_time = time
    event.schedule_rules = [{"type" => 'monthly', "interval" => -1, "days" => ["monday"]}]
    event.save
    expect(event.single_events.first.occurrence.wday).to eq(1)
    expect(event.single_events.first.occurrence.min).to eq(time.min)
  end

  def create_week_based_event(time)
    event = FactoryGirl.create(:simple)
    event.start_time = time
    event.schedule_rules = [{"type" => 'weekly', "interval" => 2, "days" => ["monday"]}]
    event.save
    event
  end

  it "should create a week based rule" do
    time = Time.utc(2012, 6, 10, 20, 15, 0, 0)
    event = create_week_based_event(time)

    first_event = event.single_events.first.occurrence
    second_event = event.single_events.second.occurrence
    expect(first_event.wday).to eq(1)
    expect(first_event.min).to eq(time.min)
    expect(first_event.wday).to eq(1)

    expect(second_event).to eq(first_event + 14.days)
  end

  it "should serialize a week based rule" do
    time = Time.utc(2012, 10, 10, 20, 15, 0)
    event = create_week_based_event(time)
    expect(event.schedule_rules).to eq([
      {
        "type" => "weekly",
        "interval" => 2,
        "days" => ["monday"]
      }
    ])
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
    allow(event).to receive(:single_events).and_return(single_events)

    expect(event.closest_single_event(today)).to eq(single_event_tomorrow)
  end

  it "should find most recent single event as closest one" do
    today = Date.new(2012, 2, 2)
    yesterday = Date.new(2012, 2, 1)

    single_events = [OpenStruct.new(:occurrence => yesterday)]
    event = Event.new
    allow(event).to receive(:single_events).and_return(single_events)

    expect(event.closest_single_event(today)).to eq(single_events.first)
  end

  it "should return nil if there is no closest single event" do
    single_events = []

    event = Event.new
    allow(event).to receive(:single_events).and_return(single_events)

    expect(event.closest_single_event).to be_nil
  end

  it "should assign users as curators" do
    event = FactoryGirl.create(:simple)
    user = FactoryGirl.create(:user)

    event.curators << user

    expect(user.curated_events).to match_array([event])
  end

  it "should only find the events in cologne region" do
    event = FactoryGirl.create(:simple)
    expect(Event.in_region(event.region).count).to eq(1)
  end

  it "should not find events for wrong region" do
    event = FactoryGirl.create(:simple)
    region = RegionSlug.where(slug: "berlin").first.try(:region) || FactoryGirl.create(:berlin_region)
    expect(Event.in_region(region).count).to eq(0)
  end

  it "should find events that are in global region, no matter what region you give to it" do
    gevent = FactoryGirl.create(:global_single_event)
    bregion = RegionSlug.where(slug: "berlin").first.try(:region) || FactoryGirl.create(:berlin_region)
    kregion = RegionSlug.where(slug: "koeln").first.try(:region)  || FactoryGirl.create(:koeln_region)

    expect(Event.in_region(bregion).count).to eq(1)
    expect(Event.in_region(kregion).count).to eq(1)

    gevent.destroy
  end

  describe 'duration wandering away bug #360' do
    before do
      @event = FactoryGirl.create(:simple, schedule_yaml: "---\n:start_date: 2011-08-07 13:13:00.000000000 +02:00\n:duration: 10800\n:rrules: []\n:exrules: []\n:rtimes:\n- 2011-08-08 19:00:00.000000000 +02:00\n- 2011-11-15 19:00:00.000000000 +01:00\n- 2012-02-06 19:00:00.000000000 +01:00\n:extimes: []\n")
    end

    it "should not calculate strange durations" do
      @event.reload
      @event.start_time = Time.now
      expect(@event.duration).to eql 180
    end
  end
end
