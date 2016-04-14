require 'spec_helper'

describe SearchController, type: :controller do
  let(:single_events) { double('SingleEvents') }
  let(:region_name) { 'koeln' }
  let(:region) { double('Region') }
  let(:region_slug) { double('RegionSlug', region: region) }
  let(:search_params) { 'SearchParams' }
  let(:search_results) { double('SingleEventsByDay') }

  before do
    allow(RegionSlug).to receive(:find_by_slug).with(region_name).and_return(region_slug)
    allow(RegionSlug).to receive(:find_by_slug).with(nil).and_return(nil)
    allow(SingleEvent).to receive(:search_in_region)
      .with(search_params, region)
      .and_return(single_events)
  end

  it 'should sort the search results from the database by day' do
    allow(SingleEventsByDay).to receive(:new)
      .with(single_events)
      .and_return(search_results)
    get :index, search: search_params, region: region_name
    expect(assigns[:search_result]).to be search_results
  end

end
