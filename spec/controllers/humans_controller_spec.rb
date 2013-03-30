require 'spec_helper'

describe HumansController do
  include Devise::TestHelpers
  render_views

  it "should get index" do
    get :index
    response.should be_success
  end

  ["html", "text"].each do |format|
    it "should show bodo in the #{format} team list" do
      bodo = FactoryGirl.create(:bodo)

      get :index, format: format
      response.body.should =~ /#{bodo.nickname}/
    end

    it "should not show random guy in the #{format} team list" do
      tester = FactoryGirl.create(:user)

      get :index, format: format
      response.body.should_not =~ /#{tester.nickname}/
    end

    it "should show bodo's team name in the #{format} team list" do
      bodo = FactoryGirl.create(:bodo)

      get :index, format: format
      response.body.should =~ /#{bodo.team}/
    end

    it "should show bodo's places on the web in the #{format} team list" do
      bodo = FactoryGirl.create(:bodo)

      get :index, format: format
      response.body.should =~ /#{bodo.twitter}/
      response.body.should =~ /#{bodo.github}/
      response.body.should =~ /#{bodo.homepage}/
    end
  end
end
