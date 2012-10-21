module WelcomeContentHelper
  def add_carousel_link(f)
    image = f.input :carousel_Bpost_id,
      label: "Choose BlogPost",
      as: :select,
      collection: BlogPost.all.map{|u| [u.headline, u.id]}
    image_id = f.input :carousel_image_id,
      as: :select,
      collection: Picture.all.map{|u| [u.title, u.id]}

    link_to "New carousel", "#", "data-partial1" => "#{h(image)}", "data-partial2" => "#{h(image_id)}", :class => 'add_task'
  end

  def type_of(box)
    unless WelcomeContent.last.nil?
      type = WelcomeContent.last.send("#{box}")["type"]

      if type == "BlogPost"
        'modules/articles/preview'
      elsif type == "Podcast"
        'modules/articles/preview_podcast'
      else
        'modules/ads/preview'
      end
    end
  end

  def locals_for(box)
    unless WelcomeContent.last.nil?
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
        # TODO: if no image -> take a random ad image...???
        { image: image_for(box).blank? ? 'test-werbung.png' : image_for(box) }
      end
    end
  end

  def image_for(box)
    unless WelcomeContent.last.nil?
      @image_id = WelcomeContent.last.send("#{box}")["image_id"]
      Picture.find(@image_id).image unless @image_id.blank?
    end
  end

  def carousel_items
    if WelcomeContent.last.nil?
      0
    else
      #uniq items w/o starting item
      (WelcomeContent.last.carousel.keys.count / 2) - 1
    end
  end

  def image_for_carousel(position)
    unless WelcomeContent.last.nil?
      @items = WelcomeContent.last.carousel.to_a
      @images = (1...@items.size).step(2).collect { |i| @items[i] } unless @items.blank?
      @image_id = @images[position][1] unless @images.blank?
      Picture.find(@image_id).image unless @image_id.blank?
    end
  end

   def headline_for_carousel(position)
    unless WelcomeContent.last.nil?
       @items = WelcomeContent.last.carousel.to_a
       @Bposts = [@items[0]] + (2...@items.size).step(2).collect { |i| @items[i] } unless @items.blank?
       @carousel_id = @Bposts[position][1] unless @Bposts.blank?
       BlogPost.find(@carousel_id).headline unless @carousel_id.blank?
    end
   end

  def headline_teaser_for_carousel(position)
    unless WelcomeContent.last.nil?
      @items = WelcomeContent.last.carousel.to_a
      @Bposts = [@items[0]] + (2...@items.size).step(2).collect { |i| @items[i] } unless @items.blank?
      @carousel_id = @Bposts[position][1] unless @Bposts.blank?
      BlogPost.find(@carousel_id).headline_teaser unless @carousel_id.blank?
    end
  end
end
