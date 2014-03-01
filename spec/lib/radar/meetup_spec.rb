require "spec_helper"

describe Radar::Meetup do

  let(:setting) {
    RadarSetting.create(url: "http://www.meetup.com/Git-Aficionados/events/155514542/")
  }

  it "should get the next events for a meetup" do
    VCR.use_cassette('meetup_git_events') do
      events = Radar::Meetup.new(setting).next_events
      expect(events.length).to eq(12)
      expect(events[1]).to eq({:id=>"qczjhhysgbtb",
                               :url=>"http://www.meetup.com/Git-Aficionados/events/qczjhhysgbtb/",
                               :title=>"Git Aficionados Meetup",
                               :description=>"<p>Topics are coming up. Go ahead and suggest some.</p>",
                               :venue=>"Co-Up, Adalbertstraße 8, Berlin, de",
                               :updated=>Time.new(2013,12,14,16,49,18,"+01:00"),
                               :duration=>0,
                               :time=>Time.new(2014,04,15,20,00,00,"+02:00")
      })
    end
  end

  it "should generate the RadarEntries for each event on meetup" do
    VCR.use_cassette('meetup_git_create_entries') do
      Radar::Meetup.new(setting).fetch(Time.new(2014,3,1,14,00))
      event = setting.entries[1]

      expect(setting.last_processed).to eq(Time.new(2014,3,1,14,00))
      expect(setting.entries.length).to eq(12)
      expect(event.entry_id).to    eq("qczjhhysgbtb")
      expect(event.entry_date).to  eq(Time.new(2014,04,15,20,00,00,"+02:00"))
      expect(event.state).to       eq(RadarEntry::States::UNCONFIRMED)
      expect(event.content).to     eq({
        :url=>"http://www.meetup.com/Git-Aficionados/events/qczjhhysgbtb/",
        :title=>"Git Aficionados Meetup",
        :description=>"<p>Topics are coming up. Go ahead and suggest some.</p>",
        :venue=>"Co-Up, Adalbertstraße 8, Berlin, de",
        :updated=>Time.new(2013,12,14,16,49,18,"+01:00"),
        :duration=>0,
      })
      expect(event.previous_confirmed_content).to eq(nil)
    end
  end

  it "should update an event if it was already in the database" do
    VCR.use_cassette('meetup_git_update_entries') do
      event = setting.entries.create(entry_id: "qczjhhysgbtb")
      Radar::Meetup.new(setting).fetch(Time.new(2014,3,1,14,00))
      event.reload

      expect(setting.entries.length).to eq(12)
      expect(event.entry_id).to    eq("qczjhhysgbtb")
      expect(event.entry_date).to  eq(Time.new(2014,04,15,20,00,00,"+02:00"))
      expect(event.state).to       eq(RadarEntry::States::UNCONFIRMED)
      expect(event.content).to     eq({
        :url=>"http://www.meetup.com/Git-Aficionados/events/qczjhhysgbtb/",
        :title=>"Git Aficionados Meetup",
        :description=>"<p>Topics are coming up. Go ahead and suggest some.</p>",
        :venue=>"Co-Up, Adalbertstraße 8, Berlin, de",
        :updated=>Time.new(2013,12,14,16,49,18,"+01:00"),
        :duration=>0,
      })
      expect(event.previous_confirmed_content).to eq(nil)
    end
  end

  it "should not update an event that is not changed" do
    VCR.use_cassette('meetup_git_not_update_entries') do
      event = setting.entries.create(
        entry_id: "qczjhhysgbtb",
        entry_date: Time.new(2014,04,15,20,00,00,"+02:00"),
        state: RadarEntry::States::CONFIRMED,
        content: {
          :url=>"http://www.meetup.com/Git-Aficionados/events/qczjhhysgbtb/",
          :title=>"Git Aficionados Meetup",
          :description=>"<p>Topics are coming up. Go ahead and suggest some.</p>",
          :venue=>"Co-Up, Adalbertstraße 8, Berlin, de",
          :updated=>Time.new(2013,12,14,16,49,18,"+01:00"),
          :duration=>0,
        }
      )
      Radar::Meetup.new(setting).fetch(Time.new(2014,3,1,14,00))
      event.reload

      expect(setting.entries.length).to eq(12)
      expect(event.state).to eq(RadarEntry::States::CONFIRMED)
    end
  end

  it "should mark an event as deleted if it is missing from the import" do
    VCR.use_cassette('meetup_git_update_entries') do
      event = setting.entries.create(entry_id: "missing", entry_date: Time.new(2014,4,12,20,00))
      Radar::Meetup.new(setting).fetch(Time.new(2014,3,1,14,00))

      event.reload
      expect(setting.entries.length).to eq(13)
      expect(event.state).to  eq(RadarEntry::States::MISSING)
    end
  end

  it "should get the group_urlname from an meetup url" do
    expect(Radar::Meetup.new(setting).group_urlname).to eq("Git-Aficionados")
  end

  it "should get a time offset string from time in milliseconds" do
    meetup = Radar::Meetup.new(setting)
    expect(meetup.get_offset(3600000)).to eq("+01:00")
    expect(meetup.get_offset(-9000000)).to eq("-02:30")
  end

end
