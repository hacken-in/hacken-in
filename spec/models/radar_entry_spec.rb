# encoding: utf-8
require 'spec_helper'

describe RadarEntry do

  it "should update the state if item is confirmed" do
    entry = RadarEntry.create(content: {item: true}, state: RadarEntry::States::UNCONFIRMED)
    entry.confirm
    expect(entry.state).to eq(RadarEntry::States::CONFIRMED)
    expect(entry.content).to be_nil
    expect(entry.previous_confirmed_content).to eq({item: true})
  end

end
