
# encoding: utf-8
require 'spec_helper'

describe RadarSetting do

  it "should get the parser and call fetch on it" do
    expect_any_instance_of(Radar::Meetup).to receive(:fetch)
    RadarSetting.new(radar_type: "Meetup").fetch
  end

end
