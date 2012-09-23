class Suggestion < ActiveRecord::Base
  attr_accessible :name,
    :occurrence,
    :description,
    :more,
    :place

  serialize :more, Hash

  validates_presence_of :name,
    :occurrence,
    :place
end
