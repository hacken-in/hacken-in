# encoding: utf-8
require "spec_helper"

describe SingleEvent do
  let(:single_event) { FactoryGirl.create(:single_event) }
  let(:single_event2) { FactoryGirl.create(:single_event) }
  let(:event) { FactoryGirl.create(:simple) }
  let(:extended_single_event) { FactoryGirl.create(:extended_single_event) }
  let(:single_event_without_name) { FactoryGirl.create(:single_event_without_name) }
  let(:user) { FactoryGirl.create(:user) }
  let(:time_now) { Time.now }

  it "create or find" do
    single_event.should eq SingleEvent.where(event_id: single_event.event.id, occurrence: single_event.occurrence).first_or_create
  end

  it "scope single events in the future" do
    expect {
      SingleEvent.create(occurrence: 1.day.from_now, event: event)
    }.to change{ SingleEvent.in_future.count }.by 1

    expect {
      SingleEvent.create(occurrence: 1.day.ago, event: event)
    }.to change{ SingleEvent.in_future.count }.by 0
  end

  it "should generate title based on name" do
    single_event.title.should eq "SimpleEvent (SimpleSingleEventName)"
    single_event_without_name.title.should eq "SimpleEvent"
  end

  it "should sort events via date if they are not on the same day" do
    single_event.name = "A"
    single_event.occurrence = (time_now + 1.day)
    single_event.event.full_day = false
    single_event.event.save

    single_event2.name = "A"
    single_event2.occurrence = time_now
    single_event2.event.full_day = false
    single_event2.event.save

    sorted_collection = [single_event, single_event2].sort
    sorted_collection.should eq [single_event2, single_event]
  end

  it "should prefer all-day events when sorting" do
    single_event.name = "A"
    single_event.occurrence = time_now
    single_event.event.full_day = false
    single_event.event.save

    single_event2.name = "B"
    single_event2.occurrence = time_now
    single_event2.event.full_day = false
    single_event2.event.save

    sorted_collection = [single_event2, single_event].sort
    sorted_collection.should eq [single_event, single_event2]
  end

  it "should sort via title when both are all-day events" do
    single_event.name = "A"
    single_event.occurrence = time_now
    single_event.event.full_day = false
    single_event.event.save

    single_event2.name = "B"
    single_event2.occurrence = time_now
    single_event2.event.full_day = false
    single_event2.event.save

    sorted_collection = [single_event2, single_event].sort
    sorted_collection.should eq [single_event, single_event2]
  end

  it "should sort via time when both are not full day" do
    single_event.occurrence = (time_now + 1.hour)
    single_event.event.full_day = false
    single_event.event.save

    single_event2.occurrence = time_now
    single_event2.event.full_day = false
    single_event2.event.save

    sorted_collection = [single_event, single_event2].sort
    sorted_collection.should eq [single_event2, single_event]
  end

  it "should sort via title when both are at the same time" do
    single_event.name = "A"
    single_event.occurrence = time_now
    single_event.event.full_day = false
    single_event.event.save

    single_event2.name = "B"
    single_event2.occurrence = time_now
    single_event2.event.full_day = false
    single_event2.event.save

    sorted_collection = [single_event2, single_event].sort
    single_event.should eq sorted_collection.first
    single_event2.should eq sorted_collection.second
  end

  it "should generate full name and name with date" do
    single_event.full_name.should eq "SimpleEvent (SimpleSingleEventName)"
    single_event.name_with_date.should eq "SimpleEvent (SimpleSingleEventName) am #{single_event.occurrence.strftime("%d.%m.%Y um %H:%M")}"
  end

  it "should delete comment when singleevent is deleted" do
    comment = single_event.comments.build(body: "wow!")
    comment.save
    single_event.destroy
    Comment.where(id: comment.id).should be_empty
  end

  it "should generate opengraph data" do
    hash = {
      "og:country-name"=>"DE",
      "og:latitude"=>50.9490279,
      "og:locality"=>"CoWoCo, Gasmotorenfabrik, 3. Etage",
      "og:longitude"=>6.986784900000001,
      "og:postal-code"=>"51063",
      "og:street-address"=>"Deutz-Mülheimerstraße 129",
      "og:title"=>"SimpleEvent (SimpleSingleEventName) am #{extended_single_event.occurrence.strftime("%d.%m.%Y um %H:%M")}"
    }
    single_event.to_opengraph.should eq hash

    hash = {
      "og:country-name"=>"DE",
      "og:description"=>"wow this is a description",
      "og:locality"=>"CoWoCo, Gasmotorenfabrik, 3. Etage",
      "og:postal-code"=>"51063",
      "og:street-address"=>"Deutz-Mülheimerstraße 129",
      "og:title"=>"SimpleEvent (SimpleSingleEventName) am #{extended_single_event.occurrence.strftime("%d.%m.%Y um %H:%M")}"
    }

    single_event_opengraph = extended_single_event.to_opengraph
    hash.each_pair {|key, value| assert_equal single_event_opengraph[key], value}

    # The coordinates change, therefore we only check a few digits:
    assert_equal single_event_opengraph["og:latitude"].to_s[0,5], "50.94"
    assert_equal single_event_opengraph["og:longitude"].to_s[0,4], "6.98"
  end

  it "user can participate on single event" do
    single_event.users << user
    single_event.save

    single_event.users.size.should be 1
    single_event.users.should eq [user]
  end

  it "get data from event if not defined in model" do
    single_event.event.url = "http://www.example.com"
    single_event.event.full_day = true
    assert_equal "http://www.example.com", single_event.url
    single_event.should be_a_full_day

    single_event.url = "http://www.example.com/single"
    single_event.full_day = false
    assert_equal "http://www.example.com/single", single_event.url
    single_event.full_day.should be_falsey
    single_event.should_not be_a_full_day

    single_event.url = ""
    single_event.full_day = nil
    assert_equal "http://www.example.com", single_event.url
    single_event.should be_a_full_day
  end

  it "should get single event if by_tag is correct" do
    single_event.tag_list << "meintag"
    single_event.save
    single_event2.tag_list << "notmeintag"
    single_event2.save

    SingleEvent.only_tagged_with("meintag").should eq [single_event]
  end

  # TODO: is this test necessary? it is equal with the previews
  it "should get single event if event is tagged" do
    single_event.event.tag_list << "meintag"
    single_event.event.save
    single_event2.tag_list << "notmeintag"
    single_event2.save

    SingleEvent.only_tagged_with("meintag").should eq [single_event]
  end

  it "should generate ri_cal_event" do
    ical = <<ical
BEGIN:VEVENT
DTEND;VALUE=DATE-TIME:#{(single_event.occurrence + single_event.duration * 60).utc.strftime("%Y%m%dT%H%M%SZ")}
DTSTART;VALUE=DATE-TIME:#{single_event.occurrence.utc.strftime("%Y%m%dT%H%M%SZ")}
DESCRIPTION:
URL:http://hcking.dev/events/1/dates/1
SUMMARY:SimpleEvent (SimpleSingleEventName)
LOCATION:Deutz-Mülheimerstraße 129\\, 51063 Köln
END:VEVENT
ical
    single_event.to_ri_cal_event.to_s.strip.should eq ical.strip
  end

  it "should add link to description in ri_cal_event" do
    ical = <<ical
BEGIN:VEVENT
DTEND;VALUE=DATE-TIME:#{(single_event.occurrence + single_event.duration * 60).utc.strftime("%Y%m%dT%H%M%SZ")}
DTSTART;VALUE=DATE-TIME:#{single_event.occurrence.utc.strftime("%Y%m%dT%H%M%SZ")}
DESCRIPTION:http://hcking.dev/events/1/dates/1
SUMMARY:SimpleEvent (SimpleSingleEventName)
LOCATION:Deutz-Mülheimerstraße 129\\, 51063 Köln
END:VEVENT
ical
    single_event.to_ri_cal_event(true).to_s.strip.should eq ical.strip
  end

  it "should respect venue_info of event only if boolean is set" do
    single_event.event.venue_info = "VenueInfos"
    single_event.venue_info = nil
    single_event.venue_info.should eq "VenueInfos"
    single_event.use_venue_info_of_event = false
    single_event.venue_info.should be_nil
    single_event.venue_info = "Single Venue Info"
    single_event.venue_info.should eq "Single Venue Info"
    single_event.use_venue_info_of_event = true
    single_event.venue_info.should eq "Single Venue Info"
  end

  it "should fix twitter values if entered with @ in string" do
    single_event.twitter = "@wrong"
    single_event.save
    single_event.twitter.should eq "wrong"
  end

  it "should fix twitter values if entered with url instead of handle" do
    single_event.twitter = "https://twitter.com/wrong"
    single_event.save
    single_event.twitter.should eq "wrong"
  end

  it "should fix twitter hashtag if entered with # in string" do
    single_event.twitter_hashtag = "#wrong"
    single_event.save
    single_event.twitter_hashtag.should eq "wrong"
  end

  it "should only find the single events in cologne region" do
    SingleEvent.in_region(single_event.event.region).count.should == 1
  end

  it "should not find single events for wrong region" do
    region = Region.where(slug: "berlin").first || FactoryGirl.create(:berlin_region)
    SingleEvent.in_region(region).count.should == 0
  end

  it "should return the single event if it has the correct reagion and the event has not" do
    region = Region.where(slug: "berlin").first || FactoryGirl.create(:berlin_region)
    single_event.region = region
    single_event.save
    SingleEvent.in_region(region).count.should == 1
  end

  it "should not return the single event if it has a wrong region and the event has a correct one" do
    region = Region.where(slug: "berlin").first || FactoryGirl.create(:berlin_region)
    single_event.region = region
    single_event.save
    kregion = Region.where(slug: "koeln").first || FactoryGirl.create(:koeln_region)
    SingleEvent.in_region(kregion).count.should == 0
  end

  it "should find single events that are in global region, no matter what region you give to it" do
    gevent = FactoryGirl.create(:global_single_event)
    bregion = Region.where(slug: "berlin").first || FactoryGirl.create(:berlin_region)
    kregion = Region.where(slug: "koeln").first  || FactoryGirl.create(:koeln_region)

    SingleEvent.in_region(bregion).count.should == 1
    SingleEvent.in_region(kregion).count.should == 1

    gevent.destroy
  end

  it "should count the single events by city in this week" do
    koeln = FactoryGirl.create(:single_event)
    koeln.occurrence = Date.today.beginning_of_week + 1.days
    koeln.save
    berlin = FactoryGirl.create(:single_event_berlin)
    berlin.occurrence = Date.today.beginning_of_week + 4.days
    berlin.save
    berlin2 = FactoryGirl.create(:single_event_berlin)
    berlin2.occurrence = Date.today.end_of_week + 1.day
    berlin2.save
    SingleEvent.this_week_by_city.should == {
      "Berlin" => 1,
      "Köln" => 1
    }
  end

  # This describe does not do anything. "Why" you ask?
  # See #318 for details.
  describe "events_per_day_in" do
    subject { SingleEvent }

    let(:date_range) { Date.today..Date.tomorrow }
    let(:date_with_events) { Date.today }
    let(:date_without_events) { Date.tomorrow }

    before do
      SingleEvent.delete_all
      FactoryGirl.create(:single_event, occurrence: date_with_events)
      FactoryGirl.create(:single_event, occurrence: date_with_events)
    end

    it 'should give the right count for the day with events'
    it 'should give the right count for the day without events'
  end
end
