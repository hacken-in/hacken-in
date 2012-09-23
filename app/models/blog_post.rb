class BlogPost < ActiveRecord::Base
  # attr_accessible :title, :body

  has_many :comments, as: :commentable, dependent: :destroy
  belongs_to :category
  belongs_to :user

  acts_as_taggable

  after_initialize :set_defaults

  validates_presence_of :headline, :headline_teaser, :teaser_text, :text, :user, :category, :publishable_from

  scope :for_web, lambda { where( "publishable = ? and publishable_from <= ?", true, Time.zone.now ).order("publishable_from desc") }

  def self.search(search)
    find(:all, :conditions => ['headline LIKE ? OR headline_teaser LIKE ? OR teaser_text 
      LIKE ? OR text LIKE ?', "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%"])
  end

  def to_s
    headline
  end

  def to_param
    "#{id}-#{headline.parameterize}"
  end

  # This is needed for the comments controller
  def name
    headline
  end

  private

  def set_defaults
    self.publishable_from = Time.now
  end
end
