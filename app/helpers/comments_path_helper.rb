# This not ideal, but I don't know a better way right now.
# There must be a more generic way of doing this
module CommentsPathHelper

  def edit_comment_path(comment)
    if comment.commentable.class == SingleEvent
      return edit_event_single_event_comment_path({event_id: comment.commentable.event.id, single_event_id: comment.commentable.id, id: comment.id})
    else
      return edit_event_comment_path({event_id: comment.commentable.id, id: comment.id})
    end
  end

  def comment_path(comment)
    if comment.commentable.class == SingleEvent
      return event_single_event_comment_path({event_id: comment.commentable.event.id, single_event_id: comment.commentable.id, id: comment.id})
    else
      return event_comment_path({event_id: comment.commentable.id, id: comment.id})
    end
  end

  def comments_path(comment)
    if comment.commentable.class == SingleEvent
      return event_single_event_comments_path({event_id: comment.commentable.event.id, single_event_id: comment.commentable.id})
    else
      return event_comments_path({event_id: comment.commentable.id})
    end
  end

  def commentable_path(comment, opts = {})
    if comment.commentable.class == SingleEvent
      return event_single_event_path({event_id: comment.commentable.event.id, id: comment.commentable.id}.merge opts)
    else
      return event_path({id: comment.commentable.id}.merge opts)
    end
  end

end
