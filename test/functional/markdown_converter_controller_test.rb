require 'test_helper'

class Api::MarkdownConverterControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test "should render markdown" do
    text = '**STRONG**'
    get :convert, text: text

    assert_response :success
    assert_equal "<p><strong>STRONG</strong></p>\n", @response.body
  end

  test "should render nothing if no text is given" do
    get :convert

    assert_response :success
    assert @response.body.empty?
  end

end

