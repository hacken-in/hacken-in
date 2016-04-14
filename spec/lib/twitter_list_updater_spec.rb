#encoding: utf-8
require 'spec_helper'

describe TwitterListUpdater do

  before(:each) do
    @event = FactoryGirl.create(:berlin_event)
    @event.twitter = "bitboxer"
    @event.save

    event2 = FactoryGirl.create(:berlin_event)
    event2.twitter = "hacken_in"
    event2.save

    @single_event = FactoryGirl.create(:single_event)

    @koeln_region = RegionSlug.where(slug: "koeln").first.region || FactoryGirl.create(:koeln_region)

    @single_event.twitter = "another_example"
    @single_event.region = @koeln_region
    @single_event.save
  end

  it "should return a hash with all twitter nicks + region_ids" do
    region_hash = TwitterListUpdater.new.twitter_by_region
    expect(region_hash[@koeln_region.id]).to eq(["another_example"])
    expect(region_hash[@event.region.id]).to contain_exactly("bitboxer", "hacken_in")
  end

  it "should find a list to add members to" do
    entry = OpenStruct.new(name: "Köln")
    client = instance_double(Twitter::REST::Client)

    expect(client).to receive(:lists).and_return([entry])
    expect(TwitterListUpdater.new(client).list_for_region(@koeln_region)).to eq(entry)
  end

  it "should find a create list if it does not exist" do
    berlin= OpenStruct.new(name: "Berlin")
    koeln = OpenStruct.new(name: "Köln")
    client = instance_double(Twitter::REST::Client)

    expect(client).to receive(:lists).and_return([berlin])
    expect(client).to receive(:create_list).with("Köln").and_return(koeln)
    expect(TwitterListUpdater.new(client).list_for_region(@koeln_region)).to eq(koeln)
  end

  it "should get a list of members of a twitter list" do
    list = OpenStruct.new(name: "Köln")
    entry = OpenStruct.new(screen_name: "colognerb")
    client = instance_double(Twitter::REST::Client)

    expect(client).to receive(:list_members).with(list, {:include_user_entities=>false, :skip_status=>true, :count=>200}).and_return([entry])
    expect(TwitterListUpdater.new(client).members(list)).to eq([entry])
  end

  it "should add missing twitter handles to a list" do
    list = OpenStruct.new(name: "Köln")
    entry = OpenStruct.new(screen_name: "colognerb")

    client = instance_double(Twitter::REST::Client)

    expect(client).to receive(:list_members).with(list, {:include_user_entities=>false, :skip_status=>true, :count=>200}).and_return([entry])
    expect(client).to receive(:add_list_member).with(list, "another_example").and_return([])

    TwitterListUpdater.new(client).add_missing_to_list(["another_example"],list)
  end

  it "should update all region lists and add missing handles" do
    berlin= OpenStruct.new(name: "Berlin")
    koeln = OpenStruct.new(name: "Köln")
    entry = OpenStruct.new(screen_name: "bitboxer")

    client = instance_double(Twitter::REST::Client)

    expect(client).to receive(:lists).and_return([berlin, koeln])
    expect(client).to receive(:list_members).with(berlin, {:include_user_entities=>false, :skip_status=>true, :count=>200}).and_return([entry])
    expect(client).to receive(:list_members).with(koeln, {:include_user_entities=>false, :skip_status=>true, :count=>200}).and_return([entry])
    expect(client).to receive(:add_list_member).with(koeln, "another_example").and_return([])

    TwitterListUpdater.new(client).update
  end

end
