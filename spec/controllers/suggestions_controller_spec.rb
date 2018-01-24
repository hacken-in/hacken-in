require 'spec_helper'

describe SuggestionsController, type: :controller do
  it "should get new" do
    get :new
    expect(response).to be_success
  end

end
