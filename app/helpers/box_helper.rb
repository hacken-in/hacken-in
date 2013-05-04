module BoxHelper

  def target_url(box)
    if box.is_ad?
      box.ad.present? ? box.ad.link : 'mailto:jan@railslove.com'
    elsif box.content.respond_to? :event
      url_for [box.content.event, box.content]
    else
      url_for [box.content]
    end
  end

  def image_for(box)
    box.picture.box_image.url
  end

end
