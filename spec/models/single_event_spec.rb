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
    expect(single_event).to eq SingleEvent.where(event_id: single_event.event.id, occurrence: single_event.occurrence).first_or_create
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
    expect(single_event.title).to eq "SimpleEvent (SimpleSingleEventName)"
    expect(single_event_without_name.title).to eq "SimpleEvent"
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
    expect(sorted_collection).to eq [single_event2, single_event]
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
    expect(sorted_collection).to eq [single_event, single_event2]
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
    expect(sorted_collection).to eq [single_event, single_event2]
  end

  it "should sort via time when both are not full day" do
    single_event.occurrence = (time_now + 1.hour)
    single_event.event.full_day = false
    single_event.event.save

    single_event2.occurrence = time_now
    single_event2.event.full_day = false
    single_event2.event.save

    sorted_collection = [single_event, single_event2].sort
    expect(sorted_collection).to eq [single_event2, single_event]
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
    expect(single_event).to eq sorted_collection.first
    expect(single_event2).to eq sorted_collection.second
  end

  it "should generate full name and name with date" do
    expect(single_event.full_name).to eq "SimpleEvent (SimpleSingleEventName)"
    expect(single_event.name_with_date).to eq "SimpleEvent (SimpleSingleEventName) am #{single_event.occurrence.strftime("%d.%m.%Y um %H:%M")}"
  end

  it "should delete comment when singleevent is deleted" do
    comment = single_event.comments.build(body: "wow!")
    comment.save
    single_event.destroy
    expect(Comment.where(id: comment.id)).to be_empty
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
    expect(single_event.to_opengraph).to eq hash

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

    expect(single_event.users.size).to be 1
    expect(single_event.users).to eq [user]
  end

  it "get data from event if not defined in model" do
    single_event.event.url = "http://www.example.com"
    single_event.event.full_day = true
    assert_equal "http://www.example.com", single_event.url
    expect(single_event).to be_a_full_day

    single_event.url = "http://www.example.com/single"
    single_event.full_day = false
    assert_equal "http://www.example.com/single", single_event.url
    expect(single_event.full_day).to be_falsey
    expect(single_event).not_to be_a_full_day

    single_event.url = ""
    single_event.full_day = nil
    assert_equal "http://www.example.com", single_event.url
    expect(single_event).to be_a_full_day
  end

  it "should get single event if by_tag is correct" do
    single_event.tag_list << "meintag"
    single_event.save
    single_event2.tag_list << "notmeintag"
    single_event2.save

    expect(SingleEvent.only_tagged_with("meintag")).to eq [single_event]
  end

  # TODO: is this test necessary? it is equal with the previews
  it "should get single event if event is tagged" do
    single_event.event.tag_list << "meintag"
    single_event.event.save
    single_event2.tag_list << "notmeintag"
    single_event2.save

    expect(SingleEvent.only_tagged_with("meintag")).to eq [single_event]
  end

  it "should generate ical_event" do
    stamp = DateTime.now
    ical = <<ical
BEGIN:VEVENT
DESCRIPTION:
DTEND:#{(single_event.occurrence + single_event.duration * 60).strftime("%Y%m%dT%H%M%S")}
DTSTAMP:#{stamp.strftime("%Y%m%dT%H%M%S")}
DTSTART:#{single_event.occurrence.strftime("%Y%m%dT%H%M%S")}
LOCATION:Deutz-Mülheimerstraße 129\\, 51063 Köln
SEQUENCE:0
SUMMARY:SimpleEvent (SimpleSingleEventName)
UID:uid
URL:http://hacken.dev/events/#{single_event.event.id}/dates/#{single_event.id}
END:VEVENT
ical
    event = single_event.to_ical_event
    event.uid = "uid"
    event.dtstamp = stamp
    expect(event.to_ical.strip.gsub("\r\n", "\n")).to eq ical.strip
  end

  it "should respect venue_info of event only if boolean is set" do
    single_event.event.venue_info = "VenueInfos"
    single_event.venue_info = nil
    expect(single_event.venue_info).to eq "VenueInfos"
    single_event.use_venue_info_of_event = false
    expect(single_event.venue_info).to be_nil
    single_event.venue_info = "Single Venue Info"
    expect(single_event.venue_info).to eq "Single Venue Info"
    single_event.use_venue_info_of_event = true
    expect(single_event.venue_info).to eq "Single Venue Info"
  end

  it "should fix twitter values if entered with @ in string" do
    single_event.twitter = "@wrong"
    single_event.save
    expect(single_event.twitter).to eq "wrong"
  end

  it "should fix twitter values if entered with url instead of handle" do
    single_event.twitter = "https://twitter.com/wrong"
    single_event.save
    expect(single_event.twitter).to eq "wrong"
  end

  it "should fix twitter hashtag if entered with # in string" do
    single_event.twitter_hashtag = "#wrong"
    single_event.save
    expect(single_event.twitter_hashtag).to eq "wrong"
  end

  it "should only find the single events in cologne region" do
    expect(SingleEvent.in_region(single_event.event.region).count).to eq(1)
  end

  it "should not find single events for wrong region" do
    region = Region.where(slug: "berlin").first || FactoryGirl.create(:berlin_region)
    expect(SingleEvent.in_region(region).count).to eq(0)
  end

  it "should return the single event if it has the correct reagion and the event has not" do
    region = Region.where(slug: "berlin").first || FactoryGirl.create(:berlin_region)
    single_event.region = region
    single_event.save
    expect(SingleEvent.in_region(region).count).to eq(1)
  end

  it "should not return the single event if it has a wrong region and the event has a correct one" do
    region = Region.where(slug: "berlin").first || FactoryGirl.create(:berlin_region)
    single_event.region = region
    single_event.save
    kregion = Region.where(slug: "koeln").first || FactoryGirl.create(:koeln_region)
    expect(SingleEvent.in_region(kregion).count).to eq(0)
  end

  it "should find single events that are in global region, no matter what region you give to it" do
    gevent = FactoryGirl.create(:global_single_event)
    bregion = Region.where(slug: "berlin").first || FactoryGirl.create(:berlin_region)
    kregion = Region.where(slug: "koeln").first  || FactoryGirl.create(:koeln_region)

    expect(SingleEvent.in_region(bregion).count).to eq(1)
    expect(SingleEvent.in_region(kregion).count).to eq(1)

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
    expect(SingleEvent.this_week_by_city).to eq({
      "Berlin" => 1,
      "Köln" => 1
    })
  end

  describe "events_per_day_in" do
    subject { SingleEvent.events_per_day_in(date_range) }

    let(:date_range) { Date.parse('2010-02-01')..Date.parse('2010-02-02') }
    let(:timestamp_with_events) { Time.parse('2010-02-01 13:00') }
    let(:timestamp_without_events) { Time.parse('2010-02-02 13:00') }

    before do
      SingleEvent.delete_all
      FactoryGirl.create(:single_event, occurrence: timestamp_with_events)
      FactoryGirl.create(:single_event, occurrence: timestamp_with_events)
    end

    it 'should give the right count for the day with events' do
      expect(subject[timestamp_with_events.to_date]).to eq 2
    end

    it 'should give the right count for the day without events' do
      expect(subject[timestamp_without_events.to_date]).to eq 0
    end
  end
end
