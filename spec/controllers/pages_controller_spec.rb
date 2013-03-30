require 'spec_helper'

describe PagesController do
  include Devise::TestHelpers
  render_views
  it "should get show" do
    get :show, {page_name: 'impressum'}

    response.should be_success
    response.body.should =~ /Impressum/
  end

  it "should get 404" do
    get :show, {page_name: "notthere"}
    response.should be_missing
  end

end
