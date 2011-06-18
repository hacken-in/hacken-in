require 'test_helper'

class EventsControllerTest < ActionController::TestCase

  test "should get event" do
    event = FactoryGirl.create(:simple)
    get :show, :id => event.id
    assert_response :success
  end

  test "should not edit if not bodo" do
    event = FactoryGirl.create(:simple)
    get :edit, :id => event.id
    assert_redirected_to :controller => 'welcome', :action => 'index'

    sign_in FactoryGirl.create(:user)
    get :edit, :id => event.id
    assert_redirected_to :controller => 'welcome', :action => 'index'
  end

  test "should edit if bodo" do
    event = FactoryGirl.create(:simple)
    sign_in FactoryGirl.create(:bodo)
    get :edit, :id => event.id
    assert_response :success
  end

end

