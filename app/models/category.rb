class Category < ActiveRecord::Base

  scope :calendar, where(calendar_category: true)

  has_many :blog_posts

  def to_param
    "#{self.id}-#{self.title.parameterize}"
  end

end
