require 'forwardable'

class Day
  extend Forwardable
  def_delegator :@sorted_events, :each

  attr_reader :date

  def initialize(date, events)
    @date = date
    @sorted_events = events.sort
  end
end
