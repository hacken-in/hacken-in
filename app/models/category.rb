class Category < ActiveRecord::Base

  has_many :blog_posts

  def to_param
    "#{self.id}-#{self.title.parameterize}"
  end

end
