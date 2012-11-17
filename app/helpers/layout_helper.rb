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
    pic = ThisiscolognePicture.order("id desc").offset(number).limit(1).first
    link_to image_tag(pic.image_url), pic.link
  end

end
