ActiveAdmin.register Box do
  menu label: "Welcome Page", priority: 1

  form do |f|
    types = {}
    [SingleEvent, BlogPost, Event].each do |model|
      types[model.model_name.human] = model
    end

    f.inputs do
      f.input :content_type, as: :select, collection: types
      f.input :content, as: :select, collection: SingleEvent.in_next(2.weeks), wrapper_html: { id: "SingleEvent" }
      f.input :content, as: :select, collection: BlogPost.most_recent, wrapper_html: { id: "BlogPost" }
      f.input :content, as: :select, collection: Event.all, wrapper_html: { id: "Event" }
    end

    f.inputs do
      f.input :carousel_position
      f.input :grid_position
    end

    f.actions
  end
end
