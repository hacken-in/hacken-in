require 'spec_helper'

describe SuggestionsController do
  include Devise::TestHelpers

  it "should get new" do
    get :new
    response.should be_success
  end

  it "should get show" do
    suggestion = FactoryGirl.create(:suggestion)

    get :show, id: suggestion.id
    response.should be_success
  end
end
