atom_feed :language => 'en-US' do |feed|
  feed.title "Nerdhub Blog"
  feed.updated @posts.first.publishable_from unless @posts.empty?

  @posts.each do |item|
    feed.entry item do |entry|
      entry.title item.headline
      item.text << "<p>#{@advertisement.description} - #{link_to(@advertisement.link, @advertisement.link)}</p>"
      entry.content item.text, :type => 'html'
      entry.author do |author|
        author.name item.user.nickname
      end
    end
  end
end
