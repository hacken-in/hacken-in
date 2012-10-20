module WelcomeContentHelper

  def add_carousel_link(f)
    image = f.input :carousel_Bpost_id, :label => "Choose BlogPost", :as => :select, :collection => BlogPost.all.map{|u| [u.headline, u.id]}
    image_id = f.input :carousel_image_id, :as => :select, :collection => Picture.all.map{|u| [u.title, u.id]}
    link_to "New carousel", "#", "data-partial1" => "#{h(image)}", "data-partial2" => "#{h(image_id)}", :class => 'add_task'
  end

  def type_of(box)
  	type = WelcomeContent.last.send("#{box}")["type"] unless WelcomeContent.last.nil?
  	if type == "BlogPost"
		  'modules/articles/preview'
	  elsif type == "Podcast"
		  'modules/articles/preview_podcast'
	  else type == "ad"                  #if no entry, place an ad....
		  'modules/ads/preview'
	  end
  end

  def locals_for(box)
    content = WelcomeContent.last.send("#{box}")
  	if content["type"] == "BlogPost" || content["type"] == "Podcast"
		  post = BlogPost.find(content["type_id"])
      {
        image: image_for(box).blank? ? 'test-werbung.png' : image_for(box).url(:small),
		    color: post.category.color,
		    subtitle: post.headline_teaser,
		    title: post.headline,
        link: blog_post_path(post.to_link)
      }
	  else content["type"] == "ad"
		  { image: image_for(box).blank? ? 'test-werbung.png' : image_for(box) } # todo: if no image -> take a random ad image...???
	  end
  end

  def image_for(box)
    @image_id = WelcomeContent.last.send("#{box}")["image_id"] unless WelcomeContent.last.nil?
  	Picture.find(@image_id).image unless @image_id.blank?
  end

  def carousel_items
    WelcomeContent.last.nil? ? 0 : (WelcomeContent.last.carousel.keys.count/2)-1  #uniq items w/o starting item
  end

  def image_for_carousel(position)
    @items = WelcomeContent.last.carousel.to_a unless WelcomeContent.last.nil?
    @images = (1...@items.size).step(2).collect { |i| @items[i] } unless @items.blank?
    @image_id = @images[position][1] unless @images.blank?
    Picture.find(@image_id).image unless @image_id.blank?
  end

   def headline_for_carousel(position)
    @items = WelcomeContent.last.carousel.to_a unless WelcomeContent.last.nil?
    @Bposts = [@items[0]] + (2...@items.size).step(2).collect { |i| @items[i] } unless @items.blank?
    @carousel_id = @Bposts[position][1] unless @Bposts.blank?
    BlogPost.find(@carousel_id).headline unless @carousel_id.blank?
  end

  def headline_teaser_for_carousel(position)
    @items = WelcomeContent.last.carousel.to_a unless WelcomeContent.last.nil?
    @Bposts = [@items[0]] + (2...@items.size).step(2).collect { |i| @items[i] } unless @items.blank?
    @carousel_id = @Bposts[position][1] unless @Bposts.blank?
    BlogPost.find(@carousel_id).headline_teaser unless @carousel_id.blank?
  end

end

