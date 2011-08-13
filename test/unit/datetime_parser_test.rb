require 'test_helper'

class DatetimeParserTest < ActiveSupport::TestCase
  include DatetimeParser

  test "parse dates" do
    params = {
      "prefix(1i)" => 1980,
      "prefix(2i)" => 5,
      "prefix(3i)" => 1,
      "prefix(4i)" => 12,
      "prefix(5i)" => 30
    }
    assert_equal Time.new(1980,5,1,12,30), parse_datetime_select(params, "prefix")
  end

  test "parse dates when they are strings" do
    params = {
      "prefix(1i)" => "1980",
      "prefix(2i)" => "5",
      "prefix(3i)" => "1",
      "prefix(4i)" => "12",
      "prefix(5i)" => "30"
    }
    assert_equal Time.new(1980,5,1,12,30), parse_datetime_select(params, "prefix")
  end

end

