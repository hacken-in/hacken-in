atom_feed :language => 'en-US' do |feed|
  feed.title "Nerdhub Blog"
  feed.updated @posts.first.publishable_from unless @posts.empty?

  @posts.each do |item|
    feed.entry item do |entry|
      entry.title item.headline
      entry.content item.text, :type => 'html'
      entry.author do |author|
        author.name item.user.nickname
      end
    end
  end
end
