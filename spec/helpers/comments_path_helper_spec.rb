require 'spec_helper'

describe CommentsPathHelper, type: :helper do
  include CommentsPathHelper

  let(:single_event) {
    FactoryGirl.create :single_event, comments: [FactoryGirl.create(:comment)]
  }

  let(:simple) {
    FactoryGirl.create :simple, comments: [FactoryGirl.create(:comment)]
  }

  it "should get edit comment path" do
    expect(edit_comment_path(single_event.comments.first)).to eq("/events/#{single_event.event.to_param}/dates/#{single_event.id}/comments/#{single_event.comments.first.id}/edit")
    expect(edit_comment_path(simple.comments.first)).to eq("/events/#{simple.to_param}/comments/#{simple.comments.first.id}/edit")
  end

  it "should get comment path" do
    expect(comment_path(single_event.comments.first)).to eq("/events/#{single_event.event.to_param}/dates/#{single_event.id}/comments/#{single_event.comments.first.id}")
    expect(comment_path(simple.comments.first)).to eq("/events/#{simple.to_param}/comments/#{simple.comments.first.id}")
  end

  it "should get comments path" do
    expect(comments_path(single_event.comments.first)).to eq("/events/#{single_event.event.to_param}/dates/#{single_event.id}/comments")
    expect(comments_path(simple.comments.first)).to eq("/events/#{simple.to_param}/comments")
  end

  it "should get commentable path" do
    expect(commentable_path(single_event.comments.first)).to eq("/events/#{single_event.event.to_param}/dates/#{single_event.id}")
    expect(commentable_path(simple.comments.first)).to eq("/events/#{simple.to_param}")
  end

end
