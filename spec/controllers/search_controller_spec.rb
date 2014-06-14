require 'spec_helper'

describe SearchController do
  let(:single_events) { double('SingleEvents') }
  let(:region_name) { 'koeln' }
  let(:region) { double('Region') }
  let(:search_params) { 'SearchParams' }
  let(:search_results) { double('SearchResults') }

  before do
    allow(Region).to receive(:find_by_slug).with(region_name).and_return(region)
    allow(Region).to receive(:find_by_slug).with(nil).and_return(nil)
    allow(SingleEvent).to receive(:search_in_region)
      .with(search_params, region)
      .and_return(single_events)
      # .with(search_params, region)
  end

  it 'should show page one of the results by default' do
    allow(SearchResult).to receive(:new)
      .with(single_events, 1)
      .and_return(search_results)
    get :index, search: search_params, region: region_name
    expect(assigns[:search_result]).to be search_results
  end

  it 'should show page two when it was requested' do
    allow(SearchResult).to receive(:new)
      .with(single_events, '2')
      .and_return(search_results)
    get :index, search: search_params, region: region_name, page: '2'
    expect(assigns[:search_result]).to be search_results
  end
end
