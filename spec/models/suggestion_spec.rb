require 'spec_helper'

describe Suggestion do
  it "should validates presence of name" do
    suggestion = FactoryGirl.build :suggestion, name: nil
    suggestion.should_not be_valid
  end

  it "should validates presence of occurrence" do
    suggestion = FactoryGirl.build :suggestion, occurrence: nil
    suggestion.should_not be_valid
  end

  it "should validates presence of place" do
    suggestion = FactoryGirl.build :suggestion, place: nil
    suggestion.should_not be_valid
  end

  it "should provides the additional information as text" do
    more_as_hash = { "a" => "b", "c" => "d" }
    more_as_text = "a: b\nc: d"

    suggestion = FactoryGirl.build :suggestion, more: more_as_hash
    suggestion.more_as_text.should == more_as_text
  end

  it "should provides the additional information in line" do
    more_as_hash = { "a" => "b", "c" => "d" }
    more_as_inline = "a: b, c: d"

    suggestion = FactoryGirl.build :suggestion, more: more_as_hash
    suggestion.more_as_inline.should == more_as_inline
  end

  it "should allows storing the additional information as text" do
    more_as_hash = { "a" => "b", "c" => "d" }
    more_as_text = "a: b\nc: d"

    suggestion = FactoryGirl.build :suggestion, more: nil
    suggestion.more_as_text = more_as_text

    suggestion.more.should == more_as_hash
  end
end
