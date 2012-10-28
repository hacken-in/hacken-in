class PodcastsController < BlogPostsController

  before_filter :sidebar_values

  def index
    @posts = BlogPost.for_web.where("mp3file is not null").page(params[:page]).per(10)
    find_post_by_params
  end

  def show
    @post = BlogPost.find(params[:id])
  end

  def feed
    @posts = BlogPost.for_web.limit(10)
    respond_to do |format|
      format.atom { render 'podcasts/feed', :layout => false }
    end
  end

  private

  def sidebar_values
    @categories = Category.unscoped.where("id in (select category_id from blog_posts where mp3file is not null)").uniq.order(:title)
    @single_events = SingleEvent.where("occurrence > ?", Time.now).limit(3)
  end
end
