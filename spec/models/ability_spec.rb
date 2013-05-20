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

  it "does not let users edit events if they are not curators" do
    user = FactoryGirl.create(:user)
    event = FactoryGirl.create(:full_event)

    ability = Ability.new(user)
    ability.should_not be_able_to :update, event
  end

  it "lets curators of events edit those events" do
    user = FactoryGirl.create(:user)
    event = FactoryGirl.create(:full_event)
    event.curators << user

    ability = Ability.new(user)
    ability.should be_able_to :update, event
  end

  it "lets curators of events edit singleevents belonging to those events" do
    user = FactoryGirl.create(:user)
    single = FactoryGirl.create(:single_event)
    single.event.curators << user

    ability = Ability.new(user)
    ability.should be_able_to :update, single
  end

end
