require 'test_helper'

class UserTagsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  [:hate, :like].each do |kind|
    test "should create new #{kind} tag" do
      user = FactoryGirl.create(:bodo)
      sign_in user

      assert_difference("user.#{kind}_list.length") do
        post :create, user_id: user.id, :"user_#{kind}_tags" => {:"#{kind}_list" => 'tag'}
        user.reload
      end
      assert_redirected_to root_path
    end

    test "should not create #{kind} tag if not logged in" do
      user = FactoryGirl.create(:bodo)

      assert_no_difference("user.#{kind}_list.length") do
        post :create, user_id: user.id, :"user_#{kind}_tags" => {:"#{kind}_list" => 'tag'}
        user.reload
      end
      assert_redirected_to root_path
    end

    test "should not create #{kind} tag if wrong user" do
      user = FactoryGirl.create(:user)
      sign_in FactoryGirl.create(:bodo)

      assert_no_difference("user.#{kind}_list.length") do
        post :create, user_id: user.id, :"user_#{kind}_tags" => {:"#{kind}_list" => 'tag'}
        user.reload
      end
      assert_redirected_to root_path
    end

    test "remove #{kind} tag" do
      user = FactoryGirl.create(:bodo)
      user.send(:"#{kind}_list") << "tag"
      user.save
      sign_in user

      assert_difference("user.#{kind}_list.length", -1) do
        delete :destroy, user_id: user.id, id: 'tag', kind: kind
        user.reload
      end
      assert_redirected_to root_path
    end

    test "remove #{kind} tag .net" do
      user = FactoryGirl.create(:bodo)
      user.send(:"#{kind}_list") << ".net"
      user.save
      sign_in user

      assert_difference("user.#{kind}_list.length", -1) do
        delete :destroy, user_id: user.id, id: '.net', kind: kind
        user.reload
      end
      assert_redirected_to root_path
    end

    test "should not remove #{kind} tag if not logged in" do
      user = FactoryGirl.create(:bodo)
      user.send(:"#{kind}_list") << "tag"
      user.save

      assert_no_difference("user.#{kind}_list.length") do
        delete :destroy, user_id: user.id, id: '.net'
        user.reload
      end
      assert_redirected_to root_path
    end

    test "should not remove #{kind} tag if wrong user" do
      user = FactoryGirl.create(:bodo)
      user.send(:"#{kind}_list") << "tag"
      user.save

      sign_in FactoryGirl.create(:user)

      assert_no_difference("user.#{kind}_list.length") do
        delete :destroy, user_id: user.id, id: 'tag'
        user.reload
      end
      assert_redirected_to root_path
    end
  end

end
