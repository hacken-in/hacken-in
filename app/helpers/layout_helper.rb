# These helper methods can be called in your template to set variables to be used in the layout
# This module should be included in all views globally,
# to do so you may need to add this line to your ApplicationController
#   helper :layout
module LayoutHelper

  def title(page_title, show_title = true)
    content_for(:title) { h(page_title.to_s) }
    @show_title = show_title
  end

  def this_is_cologne(number)
    link_to image_tag(cologne_json[number]["image_url"]), cologne_json[number]["link"]
  end

  private

  def cologne_json
    @cologne_json || load_cologne_json
  end

  def load_cologne_json
    JSON.load(open("public/thisiscologne.json"))
  end
end
