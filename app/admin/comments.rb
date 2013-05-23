#coding: utf-8

# This is called HackenComment for a technical reason:
# If you call it Comment, there is a bug that basically
# blows up everything ;)
ActiveAdmin.register Comment, as: "HackenComment" do
  index do
    column :id
    column :user do |comment|
      if (comment.user)
        span do
          avatar_for_user(comment.user)
        end
        a comment.user.nickname, href: admin_user_path(comment.user)
      else
        "Benutzer gelöscht"
      end
    end
    column :body do |comment|
      raw convert_markdown(comment.body, false)
    end
    column :commentable do |comment|
      if comment.commentable.class == SingleEvent
        link_to comment.commentable.to_s, admin_event_single_event_path(comment.commentable.event, comment.commentable)
      else
        auto_link comment.commentable
      end
    end
    column :created_at
    column :updated_at
    default_actions
  end

  show do |ad|
    attributes_table do
      row :id
      row :user do |comment|
        span do
          avatar_for_user(comment.user)
        end
        a comment.user.nickname, href: admin_user_path(comment.user)
      end
      row :body do |comment|
        convert_markdown comment.body.html_safe
      end
      row :commentable
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end

  form do |f|
    f.inputs "Kommentar" do
      f.input :user
      f.input :body
    end
    f.buttons
  end

end
