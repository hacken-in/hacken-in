require 'calendar'
require 'date'

describe Calendar do
  let(:date_one) { Date.new(2013, 12, 25) }
  let(:date_two) { Date.new(2013, 12, 26) }

  let(:event_on_date_one) { double('SingleEvent', date: date_one ) }
  let(:event_on_date_two) { double('SingleEvent', date: date_two ) }
  let(:another_event_on_date_one) { double('SingleEvent', date: date_one ) }

  let(:user) { nil }
  let(:event_list) {[ event_on_date_one, event_on_date_two, another_event_on_date_one ]}

  let(:day_class) { double('DayClass') }

  describe 'each' do
    subject { Calendar.new(event_list, user, day_class) }
    let(:day_one) { double('Day') }
    let(:day_two) { double('Day') }

    it 'should yield the first day first' do
      allow(day_class).to receive(:new)
        .with(date_one, [event_on_date_one, another_event_on_date_one])
        .and_return(day_one)

      allow(day_class).to receive(:new)
        .with(date_two, [event_on_date_two])
        .and_return(day_two)

      expect { |b| subject.each(&b) }.to yield_successive_args(day_one, day_two)
    end
  end
end
