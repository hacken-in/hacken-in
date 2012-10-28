xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0", "xmlns:itunes" => "http://www.itunes.com/dtds/podcast-1.0.dtd" do
  xml.channel do
    xml.title "Nerdhub Podcast #{@category.title}"
    xml.link podcast_categorie_url(@category)
    xml.description "Nerdhub Podcasts"
    xml.itunes :owner do
      xml.itunes :author, @posts.first.user.nickname
      xml.itunes :email, @posts.first.user.email
    end
    @posts.each do |article|
      xml.item do
        xml.title article.headline
        xml.description article.teaser_text
        xml.pubDate article.publishable_from.to_s(:rfc822)
        xml.link podcast_url(article)
        xml.guid podcast_url(article)
        xml.itunes :summary, article.teaser_text
        xml.enclosure url: "#{request.protocol}#{request.host}#{article.mp3file.url}", length: article.mp3file.size, type:"audio/mpg"
      end
    end
  end
end
