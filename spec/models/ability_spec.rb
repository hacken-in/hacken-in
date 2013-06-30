require "spec_helper"
require "cancan/matchers"

describe Ability do
  let :ability do
    described_class.new(nil)
  end

  [Comment, User].each do |klass|
    [:create, :update, :destroy].each do |action|
      it "anonym can't #{action} #{klass}" do
        ability.should_not be_able_to action, klass
      end
    end
  end

  [Event, SingleEvent, Comment, User].each do |klass|
    it "anonym can show #{klass}" do
      ability.should be_able_to :show, klass
    end
  end

  it "does not let users edit events if they are not curators or region organizers" do
    user = FactoryGirl.create(:user)
    event = FactoryGirl.create(:full_event)

    Ability.new(user).should_not be_able_to :update, event
  end

  it "lets curators of events edit those events" do
    user = FactoryGirl.create(:user)
    user2 = FactoryGirl.create(:user)
    event = FactoryGirl.create(:full_event)
    event.curators << user

    Ability.new(user).should be_able_to :update, event
    Ability.new(user2).should_not be_able_to :update, event
  end

  it "lets curators of events edit singleevents belonging to those events" do
    user = FactoryGirl.create(:user)
    user2 = FactoryGirl.create(:user)
    single = FactoryGirl.create(:single_event)
    single.event.curators << user

    Ability.new(user).should be_able_to :update, single
    Ability.new(user2).should_not be_able_to :update, single
  end

  # Region Organizers

  it "lets organizers edit events in their region" do
    user = FactoryGirl.create(:user)
    user2 = FactoryGirl.create(:user)
    event = FactoryGirl.create(:full_event)
    event.region.organizers << user

    Ability.new(user).should be_able_to :update, event
    Ability.new(user2).should_not be_able_to :update, event
  end

  it "lets organizers edit singleevents belonging to events in their region" do
    user = FactoryGirl.create(:user)
    user2 = FactoryGirl.create(:user)
    single = FactoryGirl.create(:single_event)
    single.event.region.organizers << user

    Ability.new(user).should be_able_to :update, single
    Ability.new(user2).should_not be_able_to :update, single
  end

  it "lets organizers edit venue in their region" do
    user = FactoryGirl.create(:user)
    user2 = FactoryGirl.create(:user)
    venue = FactoryGirl.create(:berlin_venue)
    venue.region.organizers << user

    Ability.new(user).should be_able_to :update, venue
    Ability.new(user2).should_not be_able_to :update, venue
  end
end
