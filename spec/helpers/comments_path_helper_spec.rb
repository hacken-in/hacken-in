require 'spec_helper'

describe CommentsPathHelper do
  include CommentsPathHelper

  it "should get edit comment path" do
    edit_comment_path(FactoryGirl.create(:single_event).comments.create).should == "/koeln/events/1-simpleevent/dates/1/comments/1/edit"
    edit_comment_path(FactoryGirl.create(:simple).comments.create).should == "/koeln/events/2-simpleevent/comments/2/edit"
  end

  it "should get comment path" do
    comment_path(FactoryGirl.create(:single_event).comments.create).should == "/koeln/events/1-simpleevent/dates/1/comments/1"
    comment_path(FactoryGirl.create(:simple).comments.create).should == "/koeln/events/2-simpleevent/comments/2"
  end

  it "should get comments path" do
    comments_path(FactoryGirl.create(:single_event).comments.create).should == "/koeln/events/1-simpleevent/dates/1/comments"
    comments_path(FactoryGirl.create(:simple).comments.create).should == "/koeln/events/2-simpleevent/comments"
  end

  it "should get commentable path" do
    commentable_path(FactoryGirl.create(:single_event).comments.create).should == "/koeln/events/1-simpleevent/dates/1"
    commentable_path(FactoryGirl.create(:simple).comments.create).should == "/koeln/events/2-simpleevent"
  end

end
