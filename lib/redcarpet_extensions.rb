class HTMLwithoutFollow < MdEmoji::Render
  def link(link, title, content)
    "<a href=\"#{link}\" #{"title=\"#{title}\" " unless title.blank?}rel=\"nofollow\">#{content}</a>"
  end
end
