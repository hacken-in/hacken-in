require 'open-uri'

namespace :this_is_cologne do

  desc "Fetch the current pictures from thisiscologne.tumblr.com"
  task :fetch_images => :environment do
    regex = /src=\"([^\"]+)\"/
    rss = Nokogiri::XML(open('http://thisiscologne.tumblr.com/rss'))
    rss.xpath('//item').each do |item|
      desc = item.css('description').text
      image = regex.match(desc)[1]
      time = Time.parse(item.css('pubDate').text)
      link = item.css('link').text
      ThisiscolognePicture.find_or_create_by_image_url(description: desc, image_url: image, link: link, time: time)
    end
  end
end
