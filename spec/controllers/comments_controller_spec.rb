require 'spec_helper'

describe CommentsController do
  include Devise::TestHelpers

  it "should do not create comment for event if not logged in" do
    simple = FactoryGirl.create(:simple)
    put :create, event_id: simple.id, comment: { body: "hallo" }
  end

  it "should do not create comment for singleevent if not logged in" do
    simple = FactoryGirl.create(:single_event)
    put :create, event_id: simple.event.id, single_event_id: simple.id, comment: { body: "hallo" }
  end

  it "should create comment for event if logged in" do
    user   = FactoryGirl.create(:user)
    simple = FactoryGirl.create(:simple)

    sign_in user
    expect {
      put :create, event_id: simple.id, comment: { body: "hallo" }
    }.to change { Comment.count }.by 1

    expect(response).to redirect_to(controller: 'events',
                                    action: 'show',
                                    id: simple.to_param,
                                    anchor: "comment_#{simple.comments.last.id}")
    simple.reload
    expect(simple.comments.last.body).to eq("hallo")
    expect(simple.comments.last.user).to eq(user)
  end

  it "should create comment for singleevent if logged in" do
    user = FactoryGirl.create(:user)
    simple = FactoryGirl.create(:single_event)

    sign_in user
    expect {
      put :create, event_id: simple.event.id, single_event_id: simple.id, comment: { body: "hallo" }
    }.to change { Comment.count }.by 1
    expect(response).to redirect_to(controller: 'single_events',
                                    action: 'show',
                                    event_id: simple.event.to_param,
                                    id: simple.id,
                                    anchor: "comment_#{simple.comments.last.id}")
    simple.reload
    expect(simple.comments.last.body).to eq("hallo")
    expect(simple.comments.last.user).to eq(user)
  end

  it "should not edit single event comment if not logged in" do
    comment = FactoryGirl.create(:single_event_comment)
    get :edit, single_event_id: comment.commentable.event.id,
               event_id: comment.commentable.id,
               id: comment.id
  end

  it "should not edit single event comment if other user" do
    comment = FactoryGirl.create(:single_event_comment)
    sign_in FactoryGirl.create(:another_user)
    get :edit, single_event_id: comment.commentable.event.id,
               event_id: comment.commentable.id,
               id: comment.id
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
  end

  it "should not edit event comment if other user" do
    comment = FactoryGirl.create(:event_comment)
    sign_in FactoryGirl.create(:another_user)
    get :edit, event_id: comment.commentable.id,
               id: comment.id
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
    comment.reload
    expect(comment.body).to eq("single event comment")
  end

  it "should not update single event comment if other user" do
    comment = FactoryGirl.create(:single_event_comment)
    sign_in FactoryGirl.create(:another_user)
    post :update, single_event_id: comment.commentable.event.id,
               event_id: comment.commentable.id,
               id: comment.id,
               comment: {body: "updated"}
    comment.reload
    expect(comment.body).to eq("single event comment")
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
                         anchor: "comment_#{comment.id}")
    comment.reload
    expect(comment.body).to eq("updated")
  end

  it "should not update event comment if not logged in" do
    comment = FactoryGirl.create(:event_comment)
    post :update, event_id: comment.commentable.id,
               id: comment.id,
               comment: {body: "updated"}
    comment.reload
    expect(comment.body).to eq("event comment")
  end

  it "should not update event comment if other user" do
    comment = FactoryGirl.create(:event_comment)
    sign_in FactoryGirl.create(:another_user)
    post :update, event_id: comment.commentable.id,
               id: comment.id,
               comment: {body: "updated"}
    comment.reload
    expect(comment.body).to eq("event comment")
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
                         anchor: "comment_#{comment.id}")
    comment.reload
    expect(comment.body).to eq("updated")
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
