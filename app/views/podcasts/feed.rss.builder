xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0",
  "xmlns:itunes" => "http://www.itunes.com/dtds/podcast-1.0.dtd",
  "xmlns:atom" => "http://www.w3.org/2005/Atom" do
  xml.channel do
    xml.title "#{@category.title}"
    xml.link podcast_categorie_url(@category)
    xml.description "Nerdhub Podcasts"
    xml.language "de"

    xml.atom :link, href: podcast_feed_url(category_id: @category.id),
       rel: "self", type: "application/rss+xml"

    xml.itunes :author, @posts.first.user.nickname
    xml.itunes :owner do
      xml.itunes :name, @posts.first.user.nickname
      xml.itunes :email, @posts.first.user.email
    end
    xml.itunes :explicit, "no"
    xml.itunes :category, text: "Gadgets"
    xml.itunes :category, text: "Tech News"
    xml.itunes :category, text: "Podcasting"
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
