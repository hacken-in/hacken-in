# encoding: utf-8
require 'spec_helper'

describe UserEditObserver do
  before(:each) do
    ActionMailer::Base.deliveries.clear
  end

  it "should send mail for updated comment" do
    comment = FactoryGirl.create(:single_event_comment)
    comment.body = "new body"
    comment.save

    ActionMailer::Base.deliveries.should_not be_empty
  end

end
