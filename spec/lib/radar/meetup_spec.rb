require "spec_helper"

describe Radar::Meetup do

  let(:setting) {
    RadarSetting.new(url: "http://www.meetup.com/Git-Aficionados/events/155514542/")
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

  it "should get the group_urlname from an meetup url" do
    expect(Radar::Meetup.new(setting).group_urlname).to eq("Git-Aficionados")
  end

  it "should get a time offset string from time in milliseconds" do
    meetup = Radar::Meetup.new(setting)
    expect(meetup.get_offset(3600000)).to eq("+01:00")
    expect(meetup.get_offset(-9000000)).to eq("-02:30")
  end

end
