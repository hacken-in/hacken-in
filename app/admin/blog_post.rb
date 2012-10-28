ActiveAdmin.register BlogPost do
  menu parent: "Content"

  index do
    column :id
    column :headline
    column :headline_teaser
    column :publishable_from
    column :publishable
    column :use_in_newsletter
    column :podcast do |post|
      post.mp3file.blank? ? "Nein" : "Ja"
    end
    default_actions
  end

  form partial: "post_form"

  show do
    render "post_partial"
  end

end
