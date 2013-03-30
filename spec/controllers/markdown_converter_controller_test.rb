require 'spec_helper'

describe Api::MarkdownConverterController do

  it "should render markdown" do
    text = '**STRONG**'
    get :convert, text: text

    response.should be_success
    response.body.should == "<p><strong>STRONG</strong></p>\n"
  end

  it "should render nothing if no text is given" do
    get :convert

    response.should be_success
    response.body.should be_empty
  end

end

