module Api
  class MarkdownConverterController < ApplicationController
    include ApplicationHelper

    def convert
      text = params[:text]

      if text
        converted_text = html_unsafe_convert_markdown(text)
        render :text => converted_text
      else
        render :text => ""
      end

    end

  end
end
