require 'spec_helper'

describe CalendarsController, type: :controller do
  let(:today) { double('Date') }
  let(:region_name) { 'koeln' }
  let(:region) { double('Region') }
  let(:region_slug) { double('RegionSlug', region: region) }
  let(:start_selector) { double('StartSelector') }
  let(:calendar) { double('Calendar') }

  before do
    allow(Date).to receive(:today).and_return(today)
    allow(RegionSlug).to receive(:find_by_slug).with(region_name).and_return(region_slug)
    allow(RegionSlug).to receive(:find_by_slug).with(nil).and_return(nil)
    allow(Calendar).to receive(:new)
  end

  it 'raises a NotFound exception when no region was given' do
    expect do
      get :show
    end.to raise_exception(ActionController::RoutingError, 'Not Found')
  end

  it "should initialize a start selector with today's date" do
    expect(StartSelector).to receive(:new).with(today).and_return(start_selector)
    get :show, region: region_name
    expect(assigns[:start_selector]).to be start_selector
  end

  context 'no user logged in' do
    it "should initialize a calendar with today's date, the current region and nil" do
      expect(Calendar).to receive(:new).with(today, region, nil).and_return(calendar)
      get :show, region: region_name
      expect(assigns[:calendar]).to be calendar
    end
  end

  context 'user logged in' do
    let(:user) { create :user }
    before { sign_in user }

    it 'should initialize a calendar with the user' do
      expect(Calendar).to receive(:new).with(today, region, user).and_return(calendar)
      get :show, region: region_name
      expect(assigns[:calendar]).to be calendar
    end
  end
end
