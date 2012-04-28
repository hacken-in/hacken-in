require 'test_helper'

class Schedule::RdatesControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test "should not delete new rdate if not bodo" do
    event = FactoryGirl.create(:simple)

    delete :destroy, :event_id => event.id, :id => 0
    assert_not_nil flash.alert
    assert_redirected_to root_path

    sign_in FactoryGirl.create(:user)
    delete :destroy, :event_id => event.id, :id => 0
    assert_not_nil flash.alert
    assert_redirected_to root_path
  end

end
