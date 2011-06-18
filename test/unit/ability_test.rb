require 'test_helper'

class AbilityTest < ActiveSupport::TestCase

  test "only bodo can edit and destroy events" do
    ability = Ability.new(FactoryGirl.create(:user))
    assert ability.cannot?(:edit, Event.new)
    assert ability.cannot?(:destroy, Event.new)

    ability = Ability.new(FactoryGirl.create(:bodo))
    assert ability.can?(:edit, Event.new)
    assert ability.can?(:destroy, Event.new)
  end

end
