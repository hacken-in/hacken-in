module PostHelper
  def post_path(controller, post)
    if controller.class == BlogPostsController
      blog_post_path(post)
    elsif controller.class == PodcastsController
      podcast_path(post)
    end
  end

  def post_categorie_path(controller, post)
    if controller.class == BlogPostsController
      blog_categorie_path(post)
    elsif controller.class == PodcastsController
      podcast_categorie_path(post)
    end
  end
end
