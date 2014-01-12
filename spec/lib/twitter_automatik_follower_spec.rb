#encoding: utf-8
require 'spec_helper'

describe TwitterAutomatikFollower do

  before(:each) do
    @event = FactoryGirl.create(:simple)
    @event.twitter = "bitboxer"
    @event.save

    @single_event = FactoryGirl.create(:single_event)
    @single_event.twitter = "another_example"
    @single_event.save

    @twitter = TwitterAutomatikFollower.new
  end

  it "should get a list of all twitter handles in the database" do
    expect(@twitter.event_twitter_handles).to eq ["bitboxer", "another_example"]
  end

  it "should get the list of currently not following twitter handles" do
    VCR.use_cassette("get list of twitter handles") do
      expect(@twitter.not_followed_handles).to eq ["another_example"]
    end
  end

  it "should try to follow the not following twitter handles" do
    VCR.use_cassette("follow twitter handles") do
      client = double("client")
      expect(client).to receive(:follow).with("another_example")
      @twitter.follow(client)
    end
  end

end
