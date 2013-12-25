require 'forwardable'

class Day
  extend Forwardable
  def_delegator :@entries, :each

  attr_reader :date

  def initialize(date, events, entry_class = CalendarEntry)
    @date = date
    @entries = events.sort.map { |event| entry_class.new(event) }
  end
end
