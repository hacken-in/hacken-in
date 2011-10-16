require 'test_helper'

class UserHateTagsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test "should create new hate tag" do
    user = FactoryGirl.create(:bodo)
    sign_in user

    assert_difference('user.hate_list.length') do
      post :create, user_id: user.id, user_hate_tags: {hate_list: 'tag'}
      user.reload
    end
    assert_redirected_to root_path
  end

  test "should not create hate tag if not logged in" do
    user = FactoryGirl.create(:bodo)

    assert_no_difference('user.hate_list.length') do
      post :create, user_id: user.id, user_hate_tags: {hate_list: 'tag'}
      user.reload
    end
    assert_redirected_to root_path
  end

  test "should not create hate tag if wrong user" do
    user = FactoryGirl.create(:user)
    sign_in FactoryGirl.create(:bodo)

    assert_no_difference('user.hate_list.length') do
      post :create, user_id: user.id, user_hate_tags: {hate_list: 'tag'}
      user.reload
    end
    assert_redirected_to root_path
  end

  test "remove hate tag" do
    user = FactoryGirl.create(:bodo)
    user.hate_list << "tag"
    user.save
    sign_in user

    assert_difference('user.hate_list.length', -1) do
      delete :destroy, user_id: user.id, id: 'tag'
      user.reload
    end
    assert_redirected_to root_path
  end

  test "remove hate tag .net" do
    user = FactoryGirl.create(:bodo)
    user.hate_list << ".net"
    user.save
    sign_in user

    assert_difference('user.hate_list.length', -1) do
      delete :destroy, user_id: user.id, id: '.net'
      user.reload
    end
    assert_redirected_to root_path
  end

  test "should not remove hate tag if not logged in" do
    user = FactoryGirl.create(:bodo)
    user.hate_list << "tag"
    user.save

    assert_no_difference('user.hate_list.length') do
      delete :destroy, user_id: user.id, id: '.net'
      user.reload
    end
    assert_redirected_to root_path
  end

  test "should not remove hate tag if wrong user" do
    user = FactoryGirl.create(:bodo)
    user.hate_list << "tag"
    user.save

    sign_in FactoryGirl.create(:user)

    assert_no_difference('user.hate_list.length') do
      delete :destroy, user_id: user.id, id: 'tag'
      user.reload
    end
    assert_redirected_to root_path
  end

end
