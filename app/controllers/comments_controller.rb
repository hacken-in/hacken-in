# encoding: utf-8
class CommentsController < ApplicationController
  respond_to :html, :xml

  def create
    @comment = find_commentable.comments.build comment_params[:comment]
    @comment.user = current_user
    authorize! :create, @comment

    if @comment.save
      flash[:notice] = t "comments.create.confirmation"
    end

    respond_with @comment,
      location: commentable_path(@comment, anchor: "comment_#{@comment.id}")
  end

  def edit
    @comment = Comment.find comment_params[:id]
    authorize! :edit, @comment
    respond_with @comment
  end

  def update
    @comment = Comment.find comment_params[:id]
    authorize! :update, @comment

    if @comment.update_attributes comment_params[:comment]
      flash[:notice] = t "comments.update.confirmation"
    end

    respond_with @comment,
      location: commentable_path(@comment, anchor: "comment_#{@comment.id}")
  end

  def destroy
    @comment = Comment.find comment_params[:id]
    authorize! :destroy, @comment

    if @comment.destroy
      flash[:notice] = t "comments.destroy.confirmation"
    end

    respond_with @comment, location: commentable_path(@comment)
  end

  private

  def comment_params
    params.permit!
  end

  # This not ideal, but I don't know a better way right now.
  # There should be no mention of the Event classes in the comments controller
  def find_commentable
    return SingleEvent.find comment_params[:single_event_id] unless comment_params[:single_event_id].nil?
    return Event.find comment_params[:event_id] unless comment_params[:event_id].nil?
    return BlogPost.find comment_params[:blog_post_id] unless comment_params[:blog_post_id].nil?
  end

end
