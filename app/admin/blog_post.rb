ActiveAdmin.register BlogPost do
  menu priority: 3

  index do
    column :id
    column :headline
    column :headline_teaser
    column :publishable_from
    column :publishable
    column :use_in_newsletter
    default_actions
  end

  form partial: "post_form"

  show do
    render "post_partial"
  end

end
