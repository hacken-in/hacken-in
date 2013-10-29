class Category < ActiveRecord::Base

  def to_param
    "#{self.id}-#{self.title.parameterize}"
  end

  def self.title_for(id)
    return "No Category" if id.nil? or !self.exists?(id)
    self.find(id).title
  end
end
