class Category < ActiveRecord::Base

  scope :calendar, where(podcast_category: false)

  has_many :blog_posts

  def to_param
    "#{self.id}-#{self.title.parameterize}"
  end

end
