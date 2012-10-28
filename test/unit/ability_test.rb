require 'test_helper'

class AbilityTest < ActiveSupport::TestCase
  test "anonym can't edit anything" do
    ability = Ability.new(nil)
    assert ability.can?(:show, Event)
    assert ability.can?(:show, SingleEvent)
    assert ability.can?(:show, Comment)
    assert ability.can?(:show, User)

    [Comment, User].each do |klass|
      assert ability.cannot?(:create, klass)
      assert ability.cannot?(:update, klass)
      assert ability.cannot?(:destroy, klass)
    end
  end
end
