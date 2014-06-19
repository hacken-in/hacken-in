require 'spec_without_rails_helper'
require 'models/single_events_by_day'

describe SingleEventsByDay do
  let(:date_one) { Date.new(2013, 12, 25) }
  let(:date_two) { Date.new(2013, 12, 26) }

  let(:event_on_date_one) { double('SingleEvent', date: date_one) }
  let(:event_on_date_two) { double('SingleEvent', date: date_two) }
  let(:another_event_on_date_one) { double('SingleEvent', date: date_one) }

  let(:event_list) {[ event_on_date_one, event_on_date_two, another_event_on_date_one ]}

  describe 'days' do
    subject { SingleEventsByDay.new(event_list) }
    let(:day_one) { double('Day') }
    let(:day_two) { double('Day') }
    let(:day_class) { double('DayClass') }

    it 'should offer the sorted days with filtered events' do
      allow(day_class).to receive(:new)
        .with(date_one, [event_on_date_one, another_event_on_date_one])
        .and_return(day_one)

      allow(day_class).to receive(:new)
        .with(date_two, [event_on_date_two])
        .and_return(day_two)

      expect(subject.days(day_class)).to eq [day_one, day_two]
    end
  end
end
