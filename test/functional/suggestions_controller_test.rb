require 'test_helper'

class SuggestionsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get show" do
    suggestion = FactoryGirl.create(:suggestion)

    get :show, id: suggestion.id
    assert_response :success
  end
end
