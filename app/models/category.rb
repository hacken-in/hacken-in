class Category < ActiveRecord::Base
  attr_accessible :title, :color

  def to_param
    "#{self.id}-#{self.title.parameterize}"
  end
end
