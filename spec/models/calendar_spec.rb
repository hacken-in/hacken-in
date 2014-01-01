require 'spec_without_rails_helper'
require 'models/calendar'
require 'date'

describe Calendar do
  let(:start_date) { double("StartDate") }
  let(:region) { double("Region") }
  let(:date_one) { Date.new(2013, 12, 25) }
  let(:date_two) { Date.new(2013, 12, 26) }

  let(:event_on_date_one) { double('SingleEvent', date: date_one) }
  let(:event_on_date_two) { double('SingleEvent', date: date_two) }
  let(:another_event_on_date_one) { double('SingleEvent', date: date_one) }
  let(:event_on_date_two_not_for_the_user) { double('SingleEvent', date: date_two) }

  let(:user) { double('User') }
  let(:event_list) {[ event_on_date_one, event_on_date_two, another_event_on_date_one, event_on_date_two_not_for_the_user ]}

  let(:day_class) { double('DayClass') }
  let(:single_event_class) { double('SingleEventClass') }

  before do
    stub_const("SingleEvent", single_event_class)
    stub_const("Day", day_class)
    allow(single_event_class).to receive(:list_all).with(from: start_date, in_next: 4.weeks, for_region: region).and_return(event_list)
    allow(event_on_date_one).to receive(:is_for_user?).with(user).and_return(true)
    allow(event_on_date_two).to receive(:is_for_user?).with(user).and_return(true)
    allow(another_event_on_date_one).to receive(:is_for_user?).with(user).and_return(true)
    allow(event_on_date_two_not_for_the_user).to receive(:is_for_user?).with(user).and_return(false)
  end

  describe 'each' do
    subject { Calendar.new(start_date, region, user) }
    let(:day_one) { double('Day') }
    let(:day_two) { double('Day') }

    before do
      allow(day_class).to receive(:new).and_return(double('Day'))
    end

    it 'should yield the first day first' do
      allow(day_class).to receive(:new)
        .with(date_one, [event_on_date_one, another_event_on_date_one])
        .and_return(day_one)

      expect { |b| subject.each(&b) }.to yield_successive_args(day_one, anything)
    end

    it 'should then yield the second day with only the events for the user' do
      allow(day_class).to receive(:new)
        .with(date_two, [event_on_date_two])
        .and_return(day_two)

      expect { |b| subject.each(&b) }.to yield_successive_args(anything, day_two)
    end
  end
end
