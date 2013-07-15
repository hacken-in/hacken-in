class SingleEventExternalUser < ActiveRecord::Base
  attr_accessible :email, :name, :single_event, :single_event_id

  belongs_to :single_event

  validates_presence_of :name
  validates_presence_of :single_event_id
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
end
