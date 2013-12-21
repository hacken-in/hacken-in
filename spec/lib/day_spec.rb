require 'day'
require 'date'

describe Day do
  let(:date) { Date.new(2013, 12, 24) }
  let(:events) { [] }
  subject { Day.new(date, events) }

  its(:date) { should be date }
end
