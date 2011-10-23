# encoding: utf-8
class CommentsController < ApplicationController

  def index
    authorize! :index, Comment
    @comments = Comment.order("created_at desc")
  end

  def create
    @comment = find_commentable.comments.build(params[:comment])
    authorize! :create, @comment
    @comment.user_id = current_user.id
    if @comment.save
      flash[:notice] = "Kommentar angelegt."
      redirect_to commentable_path(@comment, :anchor => "comment_#{@comment.id}")
    else
      redirect_to commentable_path(@comment, :body => params[:comment][:body])
    end
  end

  def show
    @comment = Comment.find(params[:id])
  end

  def edit
    @comment = Comment.find(params[:id])
    authorize! :edit, @comment
  end

  def update
    @comment = Comment.find(params[:id])
    authorize! :update, @comment
    if @comment.update_attributes(params[:comment])
      flash[:notice] = "Kommentar aktualisiert."
      redirect_to commentable_path(@comment, :anchor => "comment_#{@comment.id}")
    else
      redirect_to commentable_path(@comment, :body => params[:comment][:body])
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    authorize! :destroy, @comment
    @comment.destroy
    flash[:notice] = "Kommentar gelöscht."
    redirect_to commentable_path(@comment)
  end

  private

  # This not ideal, but I don't know a better way right now.
  # There should be no mention of the Event classes in the comments controller
  def find_commentable
    return SingleEvent.find(params[:single_event_id]) unless params[:single_event_id].nil?
    return Event.find(params[:event_id]) unless params[:event_id].nil?
  end

end
