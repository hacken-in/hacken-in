require "spec_helper"
require "cancan/matchers"

describe ActiveAdminAbility do

  it "should manage everything if user is admin" do
    user = FactoryGirl.create(:user)
    user.admin = true
    ActiveAdminAbility.new(user).should be_able_to :manage, :all
  end

  it "should only be able to edit own comments" do
    user = FactoryGirl.create(:user)
    comment = Comment.new
    comment.user_id = user.id
    comment.save
    ActiveAdminAbility.new(user).should be_able_to :update, comment
    ActiveAdminAbility.new(FactoryGirl.create(:user)).should_not be_able_to :update, comment
  end

  it "should only be able to edit events if region organizer" do
    user = FactoryGirl.create(:user)
    event = FactoryGirl.create(:full_event)
    user.region_organizers.create(region: event.region)
    ActiveAdminAbility.new(user).should be_able_to :manage, event
    ActiveAdminAbility.new(FactoryGirl.create(:user)).should_not be_able_to :manage, event
  end

  it "should only be able to edit single events if region organizer" do
    user = FactoryGirl.create(:user)
    single_event = FactoryGirl.create(:single_event_berlin)
    user.region_organizers.create(region: single_event.event.region)
    ActiveAdminAbility.new(user).should be_able_to :manage, single_event
    ActiveAdminAbility.new(FactoryGirl.create(:user)).should_not be_able_to :manage, single_event
  end

  it "should only be able to edit venues if region organizer" do
    user = FactoryGirl.create(:user)
    venue = FactoryGirl.create(:berlin_venue)
    user.region_organizers.create(region: venue.region)
    ActiveAdminAbility.new(user).should be_able_to :manage, venue
    ActiveAdminAbility.new(FactoryGirl.create(:user)).should_not be_able_to :manage, venue
  end

  it "should only be able to see the dashboard if region curator" do
    user = FactoryGirl.create(:user)
    user.region_organizers.create(region: FactoryGirl.create(:koeln_region))
    ActiveAdminAbility.new(user).should be_able_to :read, ActiveAdmin::Page
    ActiveAdminAbility.new(FactoryGirl.create(:user)).should_not be_able_to :read, ActiveAdmin::Page
  end

  it "should only be able to see the dashboard if event curator" do
    user = FactoryGirl.create(:user)
    event = FactoryGirl.create(:full_event)
    user.event_curations.create(event: event)
    ActiveAdminAbility.new(user).should be_able_to :read, ActiveAdmin::Page
    ActiveAdminAbility.new(FactoryGirl.create(:user)).should_not be_able_to :read, ActiveAdmin::Page
  end


end
