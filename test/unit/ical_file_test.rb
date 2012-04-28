# encoding: UTF-8

require 'test_helper'

class IcalFileTest < ActiveSupport::TestCase
  setup :load_ical_file

  protected

  def load_ical_file
    @dingfabrik_ical_data = File.read "data/dingfabric.ics"
    @dingfabric_ical = IcalFile.new @dingfabrik_ical_data
  end

end