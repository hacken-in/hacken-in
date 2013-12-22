require 'day'
require 'date'

describe Day do
  let(:date) { Date.new(2013, 12, 24) }
  let(:events) { double('Array') }
  let(:sorted_events) { double('Array') }
  subject { Day.new(date, events) }

  its(:date) { should be date }

  describe 'each' do
    it 'should yield the events in the right order' do
      event_1, event_2 = double, double
      events.should receive(:sort).and_return(sorted_events)
      sorted_events.should receive(:each).and_yield(event_1).and_yield(event_2)

      expect { |b| subject.each(&b) }.to yield_successive_args(event_1, event_2)
    end
  end
end
