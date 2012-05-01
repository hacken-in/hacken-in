require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test "should not get index if not admin" do
    get :index
    assert_redirected_to controller: 'welcome', action: 'index'

    sign_in FactoryGirl.create(:user)
    get :index
    assert_redirected_to controller: 'welcome', action: 'index'
  end

  test "should get index if bodo" do
    sign_in FactoryGirl.create(:bodo)
    get :index
    assert_response :success
  end

  test "do not create comment for event if not logged in" do
    simple = FactoryGirl.create(:simple)
    put :create, event_id: simple.id, comment: { body: "hallo" }
    assert_redirected_to controller: 'welcome', action: 'index'
  end

  test "do not create comment for singleevent if not logged in" do
    simple = FactoryGirl.create(:single_event)
    put :create, event_id: simple.event.id, single_event_id: simple.id, comment: { body: "hallo" }
    assert_redirected_to controller: 'welcome', action: 'index'
  end

  test "create comment for event if logged in" do
    user = FactoryGirl.create(:user)
    simple = FactoryGirl.create(:simple)

    sign_in user
    assert_difference('Comment.count') do
      put :create, event_id: simple.id, comment: { body: "hallo" }
    end
    assert_redirected_to controller: 'events', action: 'show', id: simple.to_param, anchor: "comment_1"
    simple.reload
    assert_equal "hallo", simple.comments.last.body
    assert_equal user, simple.comments.last.user
  end

  test "create comment for singleevent if logged in" do
    user = FactoryGirl.create(:user)
    simple = FactoryGirl.create(:single_event)

    sign_in user
    assert_difference('Comment.count') do
      put :create, event_id: simple.event.id, single_event_id: simple.id, comment: { body: "hallo" }
    end
    assert_redirected_to controller: 'single_events', action: 'show', event_id: simple.event.to_param, id: simple.id, anchor: "comment_1"
    simple.reload
    assert_equal "hallo", simple.comments.last.body
    assert_equal user, simple.comments.last.user
  end

  test "show singleevent comment" do
    comment = FactoryGirl.create(:single_event_comment)
    get :show, single_event_id: comment.commentable.event.id,
               event_id: comment.commentable.id,
               id: comment.id
    assert_response :success
  end

  test "show event comment" do
    comment = FactoryGirl.create(:event_comment)
    get :show, event_id: comment.commentable.id, id: comment.id
    assert_response :success
  end

  test "not edit single event comment if not logged in" do
    comment = FactoryGirl.create(:single_event_comment)
    get :edit, single_event_id: comment.commentable.event.id,
               event_id: comment.commentable.id,
               id: comment.id
    assert_redirected_to controller: 'welcome', action: 'index'
  end

  test "not edit single event comment if other user" do
    comment = FactoryGirl.create(:single_event_comment)
    sign_in FactoryGirl.create(:another_user)
    get :edit, single_event_id: comment.commentable.event.id,
               event_id: comment.commentable.id,
               id: comment.id
    assert_redirected_to controller: 'welcome', action: 'index'
  end

  test "edit single event comment if logged in" do
    comment = FactoryGirl.create(:single_event_comment)
    sign_in comment.user
    get :edit, single_event_id: comment.commentable.event.id,
               event_id: comment.commentable.id,
               id: comment.id
    assert_response :success
  end

  test "not edit event comment if not logged in" do
    comment = FactoryGirl.create(:event_comment)
    get :edit, event_id: comment.commentable.id,
               id: comment.id
    assert_redirected_to controller: 'welcome', action: 'index'
  end

  test "not edit event comment if other user" do
    comment = FactoryGirl.create(:event_comment)
    sign_in FactoryGirl.create(:another_user)
    get :edit, event_id: comment.commentable.id,
               id: comment.id
    assert_redirected_to controller: 'welcome', action: 'index'
  end

  test "edit event comment if logged in" do
    comment = FactoryGirl.create(:event_comment)
    sign_in comment.user
    get :edit, event_id: comment.commentable.id,
               id: comment.id
    assert_response :success
  end

  test "not update single event comment if not logged in" do
    comment = FactoryGirl.create(:single_event_comment)
    post :update, single_event_id: comment.commentable.event.id,
               event_id: comment.commentable.id,
               id: comment.id,
               comment: {body: "updated"}
    assert_redirected_to controller: 'welcome', action: 'index'
    comment.reload
    assert_equal "single event comment", comment.body
   end

  test "not update single event comment if other user" do
    comment = FactoryGirl.create(:single_event_comment)
    sign_in FactoryGirl.create(:another_user)
    post :update, single_event_id: comment.commentable.event.id,
               event_id: comment.commentable.id,
               id: comment.id,
               comment: {body: "updated"}
    assert_redirected_to controller: 'welcome', action: 'index'
    comment.reload
    assert_equal "single event comment", comment.body
  end

  test "update single event comment if logged in" do
    comment = FactoryGirl.create(:single_event_comment)
    sign_in comment.user
    post :update, single_event_id: comment.commentable.event.id,
               event_id: comment.commentable.id,
               id: comment.id,
               comment: {body: "updated"}
    assert_redirected_to controller: 'single_events',
                         action: 'show',
                         id: comment.commentable.to_param,
                         event_id: comment.commentable.event.to_param,
                         anchor: "comment_1"
    comment.reload
    assert_equal "updated", comment.body
  end

  test "not update event comment if not logged in" do
    comment = FactoryGirl.create(:event_comment)
    post :update, event_id: comment.commentable.id,
               id: comment.id,
               comment: {body: "updated"}
    assert_redirected_to controller: 'welcome', action: 'index'
    comment.reload
    assert_equal "event comment", comment.body
  end

  test "not update event comment if other user" do
    comment = FactoryGirl.create(:event_comment)
    sign_in FactoryGirl.create(:another_user)
    post :update, event_id: comment.commentable.id,
               id: comment.id,
               comment: {body: "updated"}
    assert_redirected_to controller: 'welcome', action: 'index'
    comment.reload
    assert_equal "event comment", comment.body
  end

  test "update event comment if logged in" do
    comment = FactoryGirl.create(:event_comment)
    sign_in comment.user
    post :update, event_id: comment.commentable.id,
               id: comment.id,
               comment: {body: "updated"}
    assert_redirected_to controller: 'events',
                         action: 'show',
                         id: comment.commentable.to_param,
                         anchor: "comment_1"
    comment.reload
    assert_equal "updated", comment.body
  end

  test "should not delete single event comment if not logged in" do
    comment = FactoryGirl.create(:single_event_comment)
    assert_no_difference('Comment.count') do
      delete :destroy, event_id: comment.commentable.event.id,
                       single_event_id: comment.commentable.id,
                       id: comment.id
    end
    assert_redirected_to root_path
  end

  test "should not delete single event comment if wrong user" do
    comment = FactoryGirl.create(:single_event_comment)
    sign_in FactoryGirl.create(:another_user)
    assert_no_difference('Comment.count') do
      delete :destroy, event_id: comment.commentable.event.id,
                       single_event_id: comment.commentable.id,
                       id: comment.id
    end
    assert_redirected_to root_path
  end

  test "should delete single event comment if correct user" do
    comment = FactoryGirl.create(:single_event_comment)
    sign_in comment.user
    assert_difference('Comment.count', -1) do
      delete :destroy, event_id: comment.commentable.event.id,
                       single_event_id: comment.commentable.id,
                       id: comment.id
    end
    assert_redirected_to controller: 'single_events',
                         action: 'show',
                         id: comment.commentable.to_param,
                         event_id: comment.commentable.event.to_param
  end

  test "should not delete event comment if not logged in" do
    comment = FactoryGirl.create(:event_comment)
    assert_no_difference('Comment.count') do
      delete :destroy, event_id: comment.commentable.id,
                       id: comment.id
    end
    assert_redirected_to root_path
  end

  test "should not delete event comment if wrong user" do
    comment = FactoryGirl.create(:event_comment)
    sign_in FactoryGirl.create(:another_user)
    assert_no_difference('Comment.count') do
      delete :destroy, event_id: comment.commentable.id,
                       id: comment.id
    end
    assert_redirected_to root_path
  end

  test "should delete event comment if correct user" do
    comment = FactoryGirl.create(:event_comment)
    sign_in comment.user
    assert_difference('Comment.count', -1) do
      delete :destroy, event_id: comment.commentable.id,
                       id: comment.id
    end
    assert_redirected_to controller: 'events',
                         action: 'show',
                         id: comment.commentable.to_param
  end

end
