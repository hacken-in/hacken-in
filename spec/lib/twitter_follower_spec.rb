#encoding: utf-8
require 'spec_helper'

describe TwitterFollower do

  before(:each) do
    @event = FactoryGirl.create(:simple)
    @event.twitter = "bitboxer"
    @event.save

    @single_event = FactoryGirl.create(:single_event)
    @single_event.twitter = "another_example"
    @single_event.save

    @twitter = TwitterFollower.new
  end

  it "should get a list of all twitter handles in the database" do
    client = instance_double(Twitter::REST::Client)
    expect(TwitterFollower.new(client).event_twitter_handles).to eq ["bitboxer", "another_example"]
  end

  it "should get the list of currently not following twitter handles" do
    entry = OpenStruct.new(handle: "Bitboxer")
    client = instance_double(Twitter::REST::Client)

    expect(client).to receive(:friends).with({:include_user_entities=>false, :skip_status=>true, :count=>200}).and_return([entry])
    expect(TwitterFollower.new(client).not_followed_handles).to eq ["another_example"]
  end

  it "should try to follow the not following twitter handles" do
    entry = OpenStruct.new(handle: "Bitboxer")
    client = instance_double(Twitter::REST::Client)
    expect(client).to receive(:friends).with({:include_user_entities=>false, :skip_status=>true, :count=>200}).and_return([entry])
    expect(client).to receive(:follow).with("another_example")
    TwitterFollower.new(client).follow
  end

end
