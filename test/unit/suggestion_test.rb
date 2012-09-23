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
end
