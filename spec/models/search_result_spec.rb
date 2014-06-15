require 'spec_without_rails_helper'
require 'models/search_result'

describe SearchResult do
  let(:single_event_on_another_page) { double('SingleEvent on another page') }
  let(:single_event) { double('SingleEvent') }
  let(:single_events) do
    [
      single_event_on_another_page,
      single_event_on_another_page,
      single_event,
      single_event,
      single_event_on_another_page
    ]
  end
  let(:page) { 2 }
  let(:entry) { double('Entry') }
  let(:entry_class) { double('EntryClass') }
  let(:per_page) { 2 }

  before do
    SearchResult.per_page = per_page

    allow(entry_class).to receive(:new)
      .twice
      .with(single_event)
      .and_return(entry)
  end

  subject { SearchResult.new(single_events, page, entry_class) }

  it 'should only return the specified number of entries per page' do
    expect(subject.entries.length).to eq per_page
  end

  it 'should return the entries wrapped in the entry class' do
    expect(subject.entries.first).to be entry
  end
end
