class EventCuration < ActiveRecord::Base
  belongs_to :user
  belongs_to :event
  attr_accessible :event
  # attr_accessible :title, :body
end
