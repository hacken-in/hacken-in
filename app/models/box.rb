class Box < ActiveRecord::Base
  attr_accessible :content_id, :content_type, :grid_position, :carousel_position

  belongs_to :content, polymorphic: true

  scope :in_grid, where("grid_position is not null").order("grid_position ASC")
  scope :first_grid_row, in_grid.where("grid_position <= 3")
  scope :second_grid_row, in_grid.where("grid_position > 3")
  scope :in_carousel, where("carousel_position is not null").order("carousel_position ASC")

  validates_uniqueness_of :grid_position, allow_nil: true
  validates_uniqueness_of :carousel_position, allow_nil: true
  validate :content_has_picture
  validates :grid_position, inclusion: {in: [1,2,3,4,5,6,nil]}
  validate :no_ad_in_the_carousel

  delegate :category, to: :content

  def is_ad?
    content_type == "Advertisement"
  end

  def ad
    throw "This is not an ad" unless is_ad?
    return Advertisement.homepage
  end

  def picture
    return Advertisement.homepage.picture if content_type == "Advertisement"
    content.picture
  end

  def first_line_for_carousel
    [:headline_teaser, :occurrence].each do |method_name|
      return content.send method_name if content.respond_to? method_name
    end

    return nil
  end

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

    return nil
  end

  def second_line?
    !!second_line
  end

  def content_has_picture
    if !is_ad? and content.picture.blank?
      errors.add(:content_id, "Selected content needs to have an image")
    end
  end

  def no_ad_in_the_carousel
    if is_ad? and carousel_position.present?
      errors.add(:carousel_position, "Sorry, you can't put advertisement into the carousel")
    end
  end
end
