require 'test_helper'

class AbilityTest < ActiveSupport::TestCase

  test "anonym can't edit anything" do
    ability = Ability.new(nil)
    assert ability.can(:show, Event.new)
    assert ability.can(:show, SingleEvent.new)
    assert ability.can(:show, Comment.new)
    assert ability.can(:show, User.new)

    [Event.new, SingleEvent.new, Comment.new, User.new].each do |obj|
      assert ability.cannot(:create, obj)
      assert ability.cannot(:update, obj)
      assert ability.cannot(:destroy, obj)
    end
  end

  test "only bodo can edit and destroy events" do
    ability = Ability.new(FactoryGirl.create(:user))
    assert ability.can(:edit, Event.new)
    assert ability.cannot?(:destroy, Event.new)

    ability = Ability.new(FactoryGirl.create(:bodo))
    assert ability.can?(:edit, Event.new)
    assert ability.can?(:destroy, Event.new)
  end

end
