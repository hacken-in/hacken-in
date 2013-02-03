require 'test_helper'

class Api::UserTagsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  [:hate, :like].each do |kind|
    test "should create new #{kind} tag" do
      user = FactoryGirl.create(:bodo)
      user.send(:"#{kind}_list") << ".net"
      user.save
      sign_in user

      assert_difference("user.#{kind}_list.length") do
        post :create, kind: kind, tags: ['tag']
        user.reload
      end
      assert_response :created
    end

    test "should not create #{kind} tag if not logged in" do
      user = FactoryGirl.create(:bodo)

      assert_no_difference("user.#{kind}_list.length") do
        post :create, kind: kind, tags: ['tag']
        user.reload
      end
      assert_response :unauthorized
    end

    test "remove #{kind} tag" do
      user = FactoryGirl.create(:bodo)
      user.send(:"#{kind}_list") << "tag"
      user.save
      sign_in user

      assert_difference("user.#{kind}_list.length", -1) do
        delete :destroy, id: 'tag', kind: kind
        user.reload
      end
      assert_response :ok
    end

    test "remove #{kind} tag .net" do
      user = FactoryGirl.create(:bodo)
      user.send(:"#{kind}_list") << ".net"
      user.send(:"#{kind}_list") << "java"
      user.save
      sign_in user

      assert_difference("user.#{kind}_list.length", -1) do
        delete :destroy, id: '.net', kind: kind
        user.reload
      end
      assert_response :ok
    end

    test "should not remove #{kind} tag if not logged in" do
      user = FactoryGirl.create(:bodo)
      user.send(:"#{kind}_list") << "tag"
      user.save

      assert_no_difference("user.#{kind}_list.length") do
        delete :destroy, id: '.net', kind: kind
        user.reload
      end
      assert_response :unauthorized
    end
  end

end
