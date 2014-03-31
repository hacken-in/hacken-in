require 'spec_helper'

describe Api::MarkdownConverterController do

  it "should render markdown" do
    text = '**STRONG**'
    get :convert, text: text

    expect(response).to be_success
    expect(response.body).to eq("<p><strong>STRONG</strong></p>\n")
  end

  it "should render nothing if no text is given" do
    get :convert

    expect(response).to be_success
    expect(response.body).to be_empty
  end

end

