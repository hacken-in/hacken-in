class HTMLwithoutFollow < Redcarpet::Render::HTML
  def link(link, title, content)
    "<a href=\"#{link}\" #{"title=\"#{title}\" " unless title.blank?}rel=\"nofollow\">#{content}</a>"
  end
end