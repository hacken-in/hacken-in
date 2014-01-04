class UserEditObserver < ActiveRecord::Observer
  observe :comment
end
