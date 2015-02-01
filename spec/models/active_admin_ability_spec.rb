require "spec_helper"
require "cancan/matchers"

describe ActiveAdminAbility do

  let(:user)  { FactoryGirl.create(:user) }
  let(:event) { FactoryGirl.create(:full_event) }

  it "should manage everything if user is admin" do
    user.admin = true
    expect(ActiveAdminAbility.new(user)).to be_able_to :manage, :all
  end

  it "should only be able to edit own comments" do
    comment = Comment.new
    comment.user_id = user.id
    comment.save
    expect(ActiveAdminAbility.new(user)).to be_able_to :update, comment
    expect(ActiveAdminAbility.new(FactoryGirl.create(:user))).not_to be_able_to :update, comment
  end

  it "should be able to create events, single_events and venues if region organizer" do
    user.region_organizers.create(region: FactoryGirl.create(:berlin_region))
    expect(ActiveAdminAbility.new(user)).to be_able_to :create, Event
    expect(ActiveAdminAbility.new(user)).to be_able_to :create, SingleEvent
    expect(ActiveAdminAbility.new(user)).to be_able_to :create, Venue
  end

  it "should only be able to edit events if region organizer" do
    user.region_organizers.create(region: event.region)
    expect(ActiveAdminAbility.new(user)).to be_able_to :manage, event
    expect(ActiveAdminAbility.new(FactoryGirl.create(:user))).not_to be_able_to :manage, event
  end

  it "should only be able to edit single events if region organizer" do
    single_event = FactoryGirl.create(:single_event_berlin)
    user.region_organizers.create(region: single_event.event.region)
    expect(ActiveAdminAbility.new(user)).to be_able_to :manage, single_event
    expect(ActiveAdminAbility.new(FactoryGirl.create(:user))).not_to be_able_to :manage, single_event
  end

  it "should only be able to edit venues if region organizer" do
    venue = FactoryGirl.create(:berlin_venue)
    user.region_organizers.create(region: venue.region)
    expect(ActiveAdminAbility.new(user)).to be_able_to :manage, venue
    expect(ActiveAdminAbility.new(FactoryGirl.create(:user))).not_to be_able_to :manage, venue
  end

  it "should only be able to see the dashboard if region curator" do
    user.region_organizers.create(region: FactoryGirl.create(:koeln_region))
    expect(ActiveAdminAbility.new(user)).to be_able_to :read, ActiveAdmin::Page
    expect(ActiveAdminAbility.new(FactoryGirl.create(:user))).not_to be_able_to :read, ActiveAdmin::Page
  end

  it "should only be able to see the dashboard if event curator" do
    user.event_curations.create(event: event)
    expect(ActiveAdminAbility.new(user)).to be_able_to :read, ActiveAdmin::Page
    expect(ActiveAdminAbility.new(FactoryGirl.create(:user))).not_to be_able_to :read, ActiveAdmin::Page
  end

  context 'radar settings' do

    before do
      @region = FactoryGirl.create(:koeln_region)
      @event = FactoryGirl.create(:full_event, region: @region)
      @radar_setting = FactoryGirl.create(:radar_setting, event: @event)
      @radar_entry = FactoryGirl.create(:radar_entry, radar_setting: @radar_setting)

      other_region = FactoryGirl.create(:berlin_region)
      other_event = FactoryGirl.create(:full_event, region: other_region)
      @other_radar_setting = FactoryGirl.create(:radar_setting, event: other_event)
      @other_radar_entry = FactoryGirl.create(:radar_entry, radar_setting: @other_radar_setting)
    end

    it 'should be managable for certain regions if user is a region organizer' do
      user.region_organizers.create(region: @region)
      expect(ActiveAdminAbility.new(user)).to be_able_to :create, RadarSetting
      expect(ActiveAdminAbility.new(user)).to be_able_to :manage, @radar_setting
      expect(ActiveAdminAbility.new(user)).not_to be_able_to :manage, @other_radar_setting
      expect(ActiveAdminAbility.new(user)).to be_able_to :manage, @radar_entry
      expect(ActiveAdminAbility.new(user)).not_to be_able_to :manage, @other_radar_entry
    end

    it 'should be managable for certain events if user is an event organizer' do
      user.event_curations.create(event: @event)
      expect(ActiveAdminAbility.new(user)).to be_able_to :create, RadarSetting
      expect(ActiveAdminAbility.new(user)).to be_able_to :manage, @radar_setting
      expect(ActiveAdminAbility.new(user)).not_to be_able_to :manage, @other_radar_setting
      expect(ActiveAdminAbility.new(user)).to be_able_to :manage, @radar_entry
      expect(ActiveAdminAbility.new(user)).not_to be_able_to :manage, @other_radar_entry
    end

  end

end
