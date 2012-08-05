ActiveAdmin.register BlogPost do

  index do
    column :id
    column :headline
    column :headline_teaser
    column :publishable
    column :publishable_from
    column :use_in_newsletter
    default_actions
  end

  form partial: "post_form"

  show do
    render "post_partial"
  end
end
