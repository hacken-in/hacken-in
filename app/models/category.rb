class Category < ActiveRecord::Base
  attr_accessible :title, :color

  def to_param
    "#{self.id}-#{self.title.parameterize}"
  end

  def self.title_for(id)
    return "No Category" if id.nil? or !self.exists?(id)
    self.find(id).title
  end
end
