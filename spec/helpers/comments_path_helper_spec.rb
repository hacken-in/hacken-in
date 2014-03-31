require 'spec_helper'

describe CommentsPathHelper do
  include CommentsPathHelper

  it "should get edit comment path" do
    expect(edit_comment_path(FactoryGirl.create(:single_event).comments.create)).to eq("/events/1-simpleevent/dates/1/comments/1/edit")
    expect(edit_comment_path(FactoryGirl.create(:simple).comments.create)).to eq("/events/2-simpleevent/comments/2/edit")
  end

  it "should get comment path" do
    expect(comment_path(FactoryGirl.create(:single_event).comments.create)).to eq("/events/1-simpleevent/dates/1/comments/1")
    expect(comment_path(FactoryGirl.create(:simple).comments.create)).to eq("/events/2-simpleevent/comments/2")
  end

  it "should get comments path" do
    expect(comments_path(FactoryGirl.create(:single_event).comments.create)).to eq("/events/1-simpleevent/dates/1/comments")
    expect(comments_path(FactoryGirl.create(:simple).comments.create)).to eq("/events/2-simpleevent/comments")
  end

  it "should get commentable path" do
    expect(commentable_path(FactoryGirl.create(:single_event).comments.create)).to eq("/events/1-simpleevent/dates/1")
    expect(commentable_path(FactoryGirl.create(:simple).comments.create)).to eq("/events/2-simpleevent")
  end

end
