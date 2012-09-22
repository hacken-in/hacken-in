require 'test_helper'

class HumansControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test "should get index" do
    get :index
    assert_response :success
  end

  ["html", "text"].each do |format|
    test "should show bodo in the #{format} team list" do
      bodo = FactoryGirl.create(:bodo)

      get :index, format: format
      assert @response.body.include? bodo.nickname
    end

    test "should not show random guy in the #{format} team list" do
      tester = FactoryGirl.create(:user)

      get :index, format: format
      assert !@response.body.include?(tester.nickname)
    end

    test "should show bodo's team name in the #{format} team list" do
      bodo = FactoryGirl.create(:bodo)

      get :index, format: format
      assert @response.body.include? bodo.team
    end

    test "should show bodo's places on the web in the #{format} team list" do
      bodo = FactoryGirl.create(:bodo)

      get :index, format: format
      assert @response.body.include? bodo.twitter
      assert @response.body.include? bodo.github
      assert @response.body.include? bodo.homepage
    end
  end
end
