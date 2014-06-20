require 'spec_without_rails_helper'
require 'models/calendar'
require 'date'

describe Calendar do
  let(:start_date) { double("StartDate") }
  let(:region) { double("Region") }

  let(:event_for_the_user) { double('SingleEvent') }
  let(:event_not_for_the_user) { double('SingleEvent') }

  let(:user) { double('User') }
  let(:event_list) {[ event_for_the_user, event_not_for_the_user ]}

  let(:single_events_by_day_class) { double('SingleEventsByDayClass') }
  let(:single_event_class) { double('SingleEventClass') }

  before do
    stub_const("SingleEvent", single_event_class)
    stub_const("SingleEventsByDay", single_events_by_day_class)
    allow(single_event_class).to receive(:list_all).with(from: start_date, in_next: 4.weeks, for_region: region).and_return(event_list)
    allow(event_for_the_user).to receive(:is_for_user?).with(user).and_return(true)
    allow(event_not_for_the_user).to receive(:is_for_user?).with(user).and_return(false)
  end

  describe 'days' do
    subject { Calendar.new(start_date, region, user) }
    let(:result) { double('Result') }
    let(:single_events_by_day) { double('SingleEventsByDay', days: result) }

    it 'should offer the sorted days with filtered events' do
      allow(single_events_by_day_class).to receive(:new)
        .with([event_for_the_user])
        .and_return(single_events_by_day)

      expect(subject.days).to be result
    end
  end
end
