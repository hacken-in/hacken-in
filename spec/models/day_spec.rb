$LOAD_PATH.unshift File.join(__dir__, '..', '..', 'app')

require 'models/day'
require 'date'

describe Day do
  let(:date) { Date.new(2013, 12, 24) }
  let(:event_1) { double('Event') }
  let(:event_2) { double('Event') }
  let(:entry_1) { double('Entry') }
  let(:entry_2) { double('Entry') }
  let(:events) { double('Array', sort: sorted_events) }
  let(:sorted_events) { [event_1, event_2] }
  let(:entry_class) { double('EntryClass') }
  subject { Day.new(date, events, entry_class) }

  it 'should set the date correctly' do
    subject.date.should be date
  end

  before do
    allow(entry_class).to receive(:new).with(event_1).and_return(entry_1)
    allow(entry_class).to receive(:new).with(event_2).and_return(entry_2)
  end

  describe 'each' do
    it 'should yield the entries in the right order' do
      expect { |b| subject.each(&b) }.to yield_successive_args(entry_1, entry_2)
    end
  end
end
