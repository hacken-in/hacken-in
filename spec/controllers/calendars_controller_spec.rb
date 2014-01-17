require 'spec_helper'

describe CalendarsController do
  let(:today) { double('Date') }
  let(:region_name) { 'koeln' }
  let(:region) { double('Region') }

  before do
    allow(Date).to receive(:today).and_return(today)
    allow(Region).to receive(:find_by_slug).with(region_name).and_return(region)
    allow(Region).to receive(:find_by_slug).with(nil).and_return(nil)
    allow(Calendar).to receive(:new)
  end

  it 'raises a NotFound exception when no region was given' do
    expect do
      get :show
    end.to raise_exception(ActionController::RoutingError, 'Not Found')
  end

  it "should initialize a start selector with today's date" do
    expect(StartSelector).to receive(:new).with(today)
    get :show, region: region_name
  end

  context 'no user logged in' do
    it "should initialize a calendar with today's date, the current region and nil" do
      expect(Calendar).to receive(:new).with(today, region, nil)
      get :show, region: region_name
    end
  end

  context 'user logged in' do
    let(:user) { create :user }
    before { sign_in user }

    it 'should initialize a calendar with the user' do
      expect(Calendar).to receive(:new).with(today, region, user)
      get :show, region: region_name
    end
  end
end
