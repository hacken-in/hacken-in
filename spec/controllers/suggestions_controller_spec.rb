require 'spec_helper'

describe SuggestionsController do
  include Devise::TestHelpers

  it "should get new" do
    get :new
    expect(response).to be_success
  end

end
