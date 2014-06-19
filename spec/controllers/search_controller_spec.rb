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
  end

  it 'should wrap the search results from the database in SearchResults' do
    allow(SearchResult).to receive(:new)
      .with(single_events)
      .and_return(search_results)
    get :index, search: search_params, region: region_name
    expect(assigns[:search_result]).to be search_results
  end

  it 'should redirect to the calendar page if no parameters where provided' do
    get :index, region: region_name
    expect(response).to redirect_to(region_path(region))
  end
end
