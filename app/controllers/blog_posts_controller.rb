class BlogPostsController < ApplicationController

  def index
    @posts = BlogPost.for_web.page(params[:page]).per(10)
    date = [params[:year], params[:month], params[:day]].join("-")
  end

  def show
    @post = BlogPost.find(params[:id])
  end

  def feed
    @posts = BlogPost.for_web.limit(10)
    respond_to do |format|
      format.atom { render :layout => false }
    end
  end

end
