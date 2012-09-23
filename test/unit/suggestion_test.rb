require 'test_helper'

class SuggestionTest < ActiveSupport::TestCase
  test "validates presence of name" do
    suggestion = FactoryGirl.build :suggestion, name: nil
    assert !suggestion.valid?
  end

  test "validates presence of occurrence" do
    suggestion = FactoryGirl.build :suggestion, occurrence: nil
    assert !suggestion.valid?
  end

  test "validates presence of place" do
    suggestion = FactoryGirl.build :suggestion, place: nil
    assert !suggestion.valid?
  end

  test "provides the additional information as text" do
    more_as_hash = { "a" => "b", "c" => "d" }
    more_as_text = "a: b\nc: d"

    suggestion = FactoryGirl.build :suggestion, more: more_as_hash
    assert_equal more_as_text, suggestion.more_as_text
  end

  test "provides the additional information in line" do
    more_as_hash = { "a" => "b", "c" => "d" }
    more_as_inline = "a: b, c: d"

    suggestion = FactoryGirl.build :suggestion, more: more_as_hash
    assert_equal more_as_inline, suggestion.more_as_inline
  end

  test "allows storing the additional information as text" do
    more_as_hash = { "a" => "b", "c" => "d" }
    more_as_text = "a: b\nc: d"

    suggestion = FactoryGirl.build :suggestion, more: nil
    suggestion.more_as_text = more_as_text

    assert_equal more_as_hash, suggestion.more
  end
end
