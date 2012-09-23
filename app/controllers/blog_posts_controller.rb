class BlogPostsController < ApplicationController

  def index
    @posts = BlogPost.for_web.page(params[:page]).per(10)
    date = [params[:year], params[:month], params[:day]].join("-")
  end

  def show
    @post = BlogPost.find(params[:id])
  end

end
