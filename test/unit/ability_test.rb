require 'test_helper'

class AbilityTest < ActiveSupport::TestCase

  test "anonym can't edit anything" do
    ability = Ability.new(nil)
    assert ability.can?(:show, Event)
    assert ability.can?(:show, SingleEvent)
    assert ability.can?(:show, Comment)
    assert ability.can?(:show, User)

    [Event, SingleEvent, Comment, User].each do |klass|
      assert ability.cannot?(:create, klass)
      assert ability.cannot?(:update, klass)
      assert ability.cannot?(:destroy, klass)
    end
  end

  test "only bodo can edit and destroy events" do
    ability = Ability.new(FactoryGirl.create(:user))
    assert ability.can?(:edit, Event)
    assert ability.cannot?(:destroy, Event)

    ability = Ability.new(FactoryGirl.create(:bodo))
    assert ability.can?(:edit, Event)
    assert ability.can?(:destroy, Event)
  end

end
