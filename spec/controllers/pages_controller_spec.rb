require 'spec_helper'

describe PagesController, type: :controller do
  include Devise::TestHelpers
  render_views
  it "should get show" do
    get :show, {page_name: 'impressum'}

    expect(response).to be_success
    expect(response.body).to match(/Impressum/)
  end

  it "should get 404" do
    get :show, {page_name: "notthere"}
    expect(response).to be_missing
  end

end
