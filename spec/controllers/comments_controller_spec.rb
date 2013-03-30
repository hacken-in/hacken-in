require 'spec_helper'

describe CommentsController do
  include Devise::TestHelpers

  it "should do not create comment for event if not logged in" do
    simple = FactoryGirl.create(:simple)
    put :create, event_id: simple.id, comment: { body: "hallo" }
    assert_redirected_to controller: 'welcome', action: 'index'
    expect(response).to redirect_to(controller: 'welcome', action: 'index')
  end

  it "should do not create comment for singleevent if not logged in" do
    simple = FactoryGirl.create(:single_event)
    put :create, event_id: simple.event.id, single_event_id: simple.id, comment: { body: "hallo" }
    expect(response).to redirect_to(controller: 'welcome', action: 'index')
  end

  it "should create comment for event if logged in" do
    user   = FactoryGirl.create(:user)
    simple = FactoryGirl.create(:simple)

    sign_in user
    expect {
      put :create, event_id: simple.id, comment: { body: "hallo" }
    }.to change { Comment.count }.by 1

    expect(response).to redirect_to(controller: 'events', action: 'show', id: simple.to_param, anchor: "comment_1")
    simple.reload
    simple.comments.last.body.should == "hallo"
    simple.comments.last.user.should == user
  end

  it "should create comment for singleevent if logged in" do
    user = FactoryGirl.create(:user)
    simple = FactoryGirl.create(:single_event)

    sign_in user
    expect {
      put :create, event_id: simple.event.id, single_event_id: simple.id, comment: { body: "hallo" }
    }.to change { Comment.count }.by 1
    expect(response).to redirect_to(controller: 'single_events', action: 'show', event_id: simple.event.to_param, id: simple.id, anchor: "comment_1")
    simple.reload
    simple.comments.last.body.should == "hallo"
    simple.comments.last.user.should == user
  end

  it "should not edit single event comment if not logged in" do
    comment = FactoryGirl.create(:single_event_comment)
    get :edit, single_event_id: comment.commentable.event.id,
               event_id: comment.commentable.id,
               id: comment.id
    expect(response).to redirect_to(controller: 'welcome', action: 'index')
  end

  it "should not edit single event comment if other user" do
    comment = FactoryGirl.create(:single_event_comment)
    sign_in FactoryGirl.create(:another_user)
    get :edit, single_event_id: comment.commentable.event.id,
               event_id: comment.commentable.id,
               id: comment.id
    expect(response).to redirect_to(controller: 'welcome', action: 'index')
  end

  it "should edit single event comment if logged in" do
    comment = FactoryGirl.create(:single_event_comment)
    sign_in comment.user
    get :edit, single_event_id: comment.commentable.event.id,
               event_id: comment.commentable.id,
               id: comment.id
    expect(response.code).to eq("200")
  end

  it "should not edit event comment if not logged in" do
    comment = FactoryGirl.create(:event_comment)
    get :edit, event_id: comment.commentable.id,
               id: comment.id
    expect(response).to redirect_to(controller: 'welcome', action: 'index')
  end

  it "should not edit event comment if other user" do
    comment = FactoryGirl.create(:event_comment)
    sign_in FactoryGirl.create(:another_user)
    get :edit, event_id: comment.commentable.id,
               id: comment.id
    expect(response).to redirect_to(controller: 'welcome', action: 'index')
  end

  it "should edit event comment if logged in" do
    comment = FactoryGirl.create(:event_comment)
    sign_in comment.user
    get :edit, event_id: comment.commentable.id,
               id: comment.id
    expect(response.code).to eq("200")
  end

  it "should not update single event comment if not logged in" do
    comment = FactoryGirl.create(:single_event_comment)
    post :update, single_event_id: comment.commentable.event.id,
               event_id: comment.commentable.id,
               id: comment.id,
               comment: {body: "updated"}
    expect(response).to redirect_to(controller: 'welcome', action: 'index')
    comment.reload
    comment.body.should == "single event comment"
  end

  it "should not update single event comment if other user" do
    comment = FactoryGirl.create(:single_event_comment)
    sign_in FactoryGirl.create(:another_user)
    post :update, single_event_id: comment.commentable.event.id,
               event_id: comment.commentable.id,
               id: comment.id,
               comment: {body: "updated"}
    expect(response).to redirect_to(controller: 'welcome', action: 'index')
    comment.reload
    comment.body.should == "single event comment"
  end

  it "should update single event comment if logged in" do
    comment = FactoryGirl.create(:single_event_comment)
    sign_in comment.user
    post :update, single_event_id: comment.commentable.event.id,
               event_id: comment.commentable.id,
               id: comment.id,
               comment: {body: "updated"}
    expect(response).to redirect_to(controller: 'single_events',
                         action: 'show',
                         id: comment.commentable.to_param,
                         event_id: comment.commentable.event.to_param,
                         anchor: "comment_1")
    comment.reload
    comment.body.should == "updated"
  end

  it "should not update event comment if not logged in" do
    comment = FactoryGirl.create(:event_comment)
    post :update, event_id: comment.commentable.id,
               id: comment.id,
               comment: {body: "updated"}
    expect(response).to redirect_to(controller: 'welcome', action: 'index')
    comment.reload
    comment.body.should == "event comment"
  end

  it "should not update event comment if other user" do
    comment = FactoryGirl.create(:event_comment)
    sign_in FactoryGirl.create(:another_user)
    post :update, event_id: comment.commentable.id,
               id: comment.id,
               comment: {body: "updated"}
    expect(response).to redirect_to(controller: 'welcome', action: 'index')
    comment.reload
    comment.body.should == "event comment"
  end

  it "should update event comment if logged in" do
    comment = FactoryGirl.create(:event_comment)
    sign_in comment.user
    post :update, event_id: comment.commentable.id,
               id: comment.id,
               comment: {body: "updated"}
    expect(response).to redirect_to(controller: 'events',
                         action: 'show',
                         id: comment.commentable.to_param,
                         anchor: "comment_1")
    comment.reload
    comment.body.should == "updated"
  end

  it "should should not delete single event comment if not logged in" do
    comment = FactoryGirl.create(:single_event_comment)
    expect {
      delete :destroy, event_id: comment.commentable.event.id,
                       single_event_id: comment.commentable.id,
                       id: comment.id
    }.to change { Comment.count }.by 0
    expect(response).to redirect_to(root_path)
  end

  it "should should not delete single event comment if wrong user" do
    comment = FactoryGirl.create(:single_event_comment)
    sign_in FactoryGirl.create(:another_user)
    expect {
      delete :destroy, event_id: comment.commentable.event.id,
                       single_event_id: comment.commentable.id,
                       id: comment.id
    }.to change { Comment.count }.by 0
    expect(response).to redirect_to(root_path)
  end

  it "should should delete single event comment if correct user" do
    comment = FactoryGirl.create(:single_event_comment)
    sign_in comment.user
    expect {
      delete :destroy, event_id: comment.commentable.event.id,
                       single_event_id: comment.commentable.id,
                       id: comment.id
    }.to change { Comment.count }.by(-1)
    expect(response).to redirect_to(controller: 'single_events',
                         action: 'show',
                         id: comment.commentable.to_param,
                         event_id: comment.commentable.event.to_param)
  end

  it "should should not delete event comment if not logged in" do
    comment = FactoryGirl.create(:event_comment)
    expect {
      delete :destroy, event_id: comment.commentable.id,
                       id: comment.id
    }.to change { Comment.count }.by 0
    expect(response).to redirect_to(root_path)
  end

  it "should should not delete event comment if wrong user" do
    comment = FactoryGirl.create(:event_comment)
    sign_in FactoryGirl.create(:another_user)
    expect {
      delete :destroy, event_id: comment.commentable.id,
                       id: comment.id
    }.to change { Comment.count }.by 0
    expect(response).to redirect_to(root_path)
  end

  it "should should delete event comment if correct user" do
    comment = FactoryGirl.create(:event_comment)
    sign_in comment.user
    expect {
      delete :destroy, event_id: comment.commentable.id,
                       id: comment.id
    }.to change { Comment.count }.by(-1)
    expect(response).to redirect_to(controller: 'events', action: 'show', id: comment.commentable.to_param)
  end
end
