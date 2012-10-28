class BlogPostsController < ApplicationController

  before_filter :sidebar_values

  def index
    @advertisement = Advertisement.first
    @posts = BlogPost.for_web.where("mp3file is null").page(params[:page]).per(10)
    find_post_by_params
  end

  def show
    @advertisement = Advertisement.first
    @post = BlogPost.find(params[:id])
  end

  def feed
    @advertisement = Advertisement.first
    @posts = BlogPost.for_web.limit(10)
    respond_to do |format|
      format.atom { render :layout => false }
    end
  end

  private

  def find_post_by_params
    if params[:year]
      start_date = DateTime.new
      end_date = start_date
      if params[:day]
        start_date = DateTime.new(params[:year].to_i, params[:month].to_i, params[:day].to_i)
        end_date = start_date
      elsif params[:month]
        start_date = DateTime.new(params[:year].to_i, params[:month].to_i)
        end_date = start_date.end_of_month
      else
        start_date = DateTime.new(params[:year].to_i)
        end_date = start_date.end_of_year
      end

      @posts = @posts.where("publishable_from >= ? and publishable_from <= ?", start_date, end_date)
    elsif params[:category_id]
      @current_category = Category.find(params[:category_id])
      @posts = @posts.where(category_id: params[:category_id])
    end
  end

  def sidebar_values
    @categories = Category.where("id in (select category_id from blog_posts where mp3file is null)").uniq.order(:title)
    @single_events = SingleEvent.where("occurrence > ?", Time.now).limit(3)
  end
end
