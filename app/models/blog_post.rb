class BlogPost < ActiveRecord::Base
  # attr_accessible :title, :body

  has_many :comments, as: :commentable, dependent: :destroy
  belongs_to :category
  belongs_to :user, class_name: "AdminUser"

  acts_as_taggable

  after_initialize :set_defaults

  validates_presence_of :headline, :headline_teaser, :teaser_text, :text, :user, :category

  def to_s
    headline
  end

  private

  def set_defaults
    self.publishable_from = Time.now
  end
end
