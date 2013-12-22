require 'day'
require 'date'

describe Day do
  let(:date) { Date.new(2013, 12, 24) }
  let(:events) { double('Array', sort: sorted_events) }
  let(:event_1) { double('Event') }
  let(:event_2) { double('Event') }
  let(:sorted_events) { [event_1, event_2] }
  subject { Day.new(date, events) }

  its(:date) { should be date }

  describe 'each' do
    it 'should yield the events in the right order' do
      expect { |b| subject.each(&b) }.to yield_successive_args(event_1, event_2)
    end
  end
end
