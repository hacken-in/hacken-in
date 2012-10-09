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
  	type = WelcomeContent.last.send("#{box}")["type"] unless WelcomeContent.last.nil?
  	if type == "BlogPost"
		  { image: image_for(box).blank? ? 'test-werbung.png' : image_for(box).url(:small),
		  color: color_for(box), 
		  subtitle: subtitle_for(box), 
		  title: title_for(box) }
	  elsif type == "Podcast"
		  { image: image_for(box).blank? ? 'test-werbung.png' : image_for(box),
		  subtitle: subtitle_for(box),  
 		  title: title_for(box) }
	  else type == "ad"
		  { image: image_for(box).blank? ? 'test-werbung.png' : image_for(box) } # todo: if no image -> take a random ad image...???
	  end
  end


  def image_for(box)
    @image_id = WelcomeContent.last.send("#{box}")["image_id"] unless WelcomeContent.last.nil?
  	Picture.find(@image_id).image unless @image_id.blank?
  end

  def color_for(box)
  	@box_id = WelcomeContent.last.send("#{box}")["type_id"]
  	@blog_post = BlogPost.find(@box_id).category_id
  	Category.find(@blog_post).color unless @blog_post.blank?
  end

  def subtitle_for(box)
  	@box_id = WelcomeContent.last.send("#{box}")["type_id"]
  	BlogPost.find(@box_id).headline_teaser unless @box_id.blank?
  end

  def title_for(box)
  	@box_id = WelcomeContent.last.send("#{box}")["type_id"]
  	BlogPost.find(@box_id).headline unless @box_id.blank?
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

