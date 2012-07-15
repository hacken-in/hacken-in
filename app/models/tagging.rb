class Tagging < ActiveRecord::Base
  belongs_to :tag
  belongs_to :taggable, polymorphic: true

  scope :tags,  where("context = 'tags'")
  scope :likes, where("context = 'likes'")
  scope :hates, where("context = 'hates'")

  def Tagging.distribution
    tags.group(:tag_id).count.map do |tag_id, amount|
      [Tag.find(tag_id).name, amount]
    end.sort { |a,b| b[1] <=> a[1]}
  end
end
