class Box < ActiveRecord::Base
  attr_accessible :content_id, :content_type, :grid_position

  belongs_to :content, polymorphic: true

  scope :in_grid, where("grid_position is not null").order("grid_position ASC")

  validates_uniqueness_of :grid_position, allow_nil: true
  validate :content_has_picture
  validates :grid_position, inclusion: {in: [1,2,3,4,5,6,nil]}

  delegate :picture, to: :content
  delegate :category, to: :content

  def first_line
    [:teaser_text, :occurrence].each do |method_name|
      return content.send method_name if content.respond_to? method_name
    end

    return nil
  end

  def first_line?
    !!first_line
  end

  def second_line
    [:headline, :title].each do |method_name|
      return content.send method_name if content.respond_to? method_name
    end
  end

  def second_line?
    !!second_line
  end

  def content_has_picture
    if content.picture.blank?
      errors.add(:content_id, "Selected content needs to have an image")
    end
  end
end
