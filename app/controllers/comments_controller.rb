# encoding: utf-8
class CommentsController < ApplicationController
  respond_to :html, :xml

  def index
    authorize! :manage, Comment
    @comments = Comment.order("created_at desc")
    respond_with @comments
  end

  def create
    @comment = find_commentable.comments.build(params[:comment])
    @comment.user = current_user
    authorize! :create, @comment

    if @comment.save
      flash[:notice] = t "comments.create.confirmation"
    end

    respond_with @comment, location: commentable_path(@comment, anchor: "comment_#{@comment.id}")
  end

  def show
    @comment = Comment.find(params[:id])
    respond_with @comment
  end

  def edit
    @comment = Comment.find(params[:id])
    authorize! :edit, @comment
    respond_with @comment
  end

  def update
    @comment = Comment.find(params[:id])
    authorize! :update, @comment

    if @comment.update_attributes(params[:comment])
      flash[:notice] = t "comments.update.confirmation"
    end

    respond_with @comment, location: commentable_path(@comment, anchor: "comment_#{@comment.id}")
  end

  def destroy
    @comment = Comment.find(params[:id])
    authorize! :destroy, @comment

    if @comment.destroy
      flash[:notice] = t "comments.destroy.confirmation"
    end

    respond_with @comment, location: commentable_path(@comment)
  end

  private

  # This not ideal, but I don't know a better way right now.
  # There should be no mention of the Event classes in the comments controller
  def find_commentable
    return SingleEvent.find(params[:single_event_id]) unless params[:single_event_id].nil?
    return Event.find(params[:event_id]) unless params[:event_id].nil?
  end

end
