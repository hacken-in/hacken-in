require "spec_helper"

describe DatetimeParser do
  include DatetimeParser

  it "should parse a date as numbers" do
    params = {
      "prefix(1i)" => 1980,
      "prefix(2i)" => 5,
      "prefix(3i)" => 1,
      "prefix(4i)" => 12,
      "prefix(5i)" => 30
    }
    parse_datetime_select(params, "prefix").should == Time.new(1980,5,1,12,30)
  end

  it "should parse dates when they are strings" do
    params = {
      "prefix(1i)" => "1980",
      "prefix(2i)" => "5",
      "prefix(3i)" => "1",
      "prefix(4i)" => "12",
      "prefix(5i)" => "30"
    }
    parse_datetime_select(params, "prefix").should == Time.new(1980,5,1,12,30)
  end
end
