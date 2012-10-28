class PodcastsController < BlogPostsController

  before_filter :sidebar_values

  def index
    @advertisement = Advertisement.first
    @posts = BlogPost.for_web.where("mp3file is not null").order("publishable_from desc").page(params[:page]).per(10)
    find_post_by_params
  end

  def show
    @advertisement = Advertisement.first    
    @post = BlogPost.find(params[:id])
  end

  def feed
    @category = Category.find(params[:category_id])
    @posts = BlogPost.for_web.where("mp3file is not null and category_id=?", params[:category_id]).limit(10)
    render 'podcasts/feed.rss', :layout => false
  end

  private

  def sidebar_values
    @categories = Category.unscoped.where("id in (select category_id from blog_posts where mp3file is not null)").uniq.order(:title)
    @single_events = SingleEvent.where("occurrence > ?", Time.now).limit(3)
  end
end
