class BlogPostsController < ApplicationController

  def index
    @posts = BlogPost.for_web.paginate(page: params[:page])
  end

end
