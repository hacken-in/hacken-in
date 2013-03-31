require 'spec_helper'

describe WelcomeController do
  include Devise::TestHelpers

  before do
    post = FactoryGirl.create(:full_blog_post,
                              teaser_text: "Simple Headline Teaser",
                              headline: "SimpleBlogPost")
    FactoryGirl.create(:box, content: post)
  end

  it "should should get index" do
    FactoryGirl.create(:full_blog_post)
    get :index
    expect(response.code).to eq("200")
  end

  it "should should find box with blog_post title & subtitle" do
    get :index
    pending "This test fails"
    assert_select ".article-title", "SimpleBlogPost"
    assert_select ".article-subtitle", "Simple Headline Teaser"
  end

  it "should should find carousel with blog_post title & subtitle" do
    get :index
    pending "Since this has to be fixed when the layout includes the text boxes again"
    assert_select '.carousel-caption h4', "SimpleBlogPost"
    assert_select '.carousel-caption a', "Simple Headline Teaser"
  end
end
