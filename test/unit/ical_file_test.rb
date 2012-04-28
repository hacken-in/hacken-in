# encoding: UTF-8

require 'test_helper'

class IcalFileTest < ActiveSupport::TestCase
  setup :load_ical_file

  test "parses the ical data from dingfabrik" do
    assert_equal 69, @dingfabric_ical.number_of_events
  end
  
  test "iterates over the events" do
    @dingfabric_ical.each_event do |event|
      assert event.summary.length > 5
      break
    end
  end
  
  test "iterates over events that match a certain expression" do
    @dingfabric_ical.each_event_with_pattern /Bastelnachmittag/ do |event|
      assert_equal "Bastelnachmittag", event.summary
    end
  end

  protected

  def load_ical_file
    dingfabrik_ical_data = File.read "data/dingfabric.ics"
    @dingfabric_ical = IcalFile.new dingfabrik_ical_data
  end

end