require 'test_helper'

class EventsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test "should get event" do
    event = FactoryGirl.create(:simple)
    get :show, :id => event.id
    assert_response :success
  end

  test "should  showing list of events" do
    get :index
    assert_response :success
  end

  test "should not edit if not bodo" do
    event = FactoryGirl.create(:simple)
    get :edit, :id => event.id
    assert_redirected_to :controller => 'welcome', :action => 'index'

    sign_in FactoryGirl.create(:user)
    get :edit, :id => event.id
    assert_redirected_to :controller => 'welcome', :action => 'index'

    post :update, :id => event.id, :event => {name: "Hallo"}
    event.reload
    assert_equal "SimpleEvent", event.name
    assert_redirected_to :controller => 'welcome', :action => 'index'
  end

  test "should not create if not bodo" do
    event = FactoryGirl.create(:simple)
    get :new
    assert_redirected_to :controller => 'welcome', :action => 'index'

    sign_in FactoryGirl.create(:user)
    get :new
    assert_redirected_to :controller => 'welcome', :action => 'index'

    assert_no_difference('Event.count') do
      put :create, :event => { name: "hallo" }
    end
    assert_redirected_to :controller => 'welcome', :action => 'index'
  end

  test "should edit if bodo" do
    event = FactoryGirl.create(:simple)
    sign_in FactoryGirl.create(:bodo)
    get :edit, :id => event.id
    assert_response :success

    put :update, :id => event.id,:event => { name: "Hallo" }
    event.reload
    assert_equal "Hallo", event.name
    assert_redirected_to event_path(event)
  end

  test "should create if bodo" do
    sign_in FactoryGirl.create(:bodo)
    get :new
    assert_response :success

    assert_difference('Event.count') do
      put :create, :event => { name: "Hallo" }
    end
    assert_equal "Hallo", assigns(:event).name
    assert_redirected_to event_path(assigns(:event))
  end

  test "should not delete if not bodo" do
    event = FactoryGirl.create(:simple)

    assert_no_difference('Event.count') do
      delete :destroy, :id => event.id
    end

    assert_redirected_to root_path
  end

  test "should delete if not bodo" do
    event = FactoryGirl.create(:simple)
    sign_in FactoryGirl.create(:bodo)

    assert_difference('Event.count', -1) do
      delete :destroy, :id => event.id
    end

    assert_redirected_to root_path
  end


end

