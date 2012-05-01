# This not ideal, but I don't know a better way right now.
# There must be a more generic way of doing this
module CommentsPathHelper

  def edit_comment_path(comment, opts = {})
    polymorphic_path((get_url_models(comment) << comment), {action: :edit}.merge(opts))
  end

  def comment_path(comment, opts = {})
    polymorphic_path((get_url_models(comment) << comment), opts)
  end

  def comments_path(comment, opts = {})
    polymorphic_path(get_url_models(comment) << Comment, opts)
  end

  def commentable_path(comment, opts = {})
    polymorphic_path(get_url_models(comment), opts)
  end

  private

  def get_url_models(comment)
    if comment.commentable.class == SingleEvent
      [comment.commentable.event, comment.commentable]
    else
      [comment.commentable]
    end
  end

end
