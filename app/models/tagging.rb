class Tagging < ActiveRecord::Base
  belongs_to :tag
  belongs_to :taggable, polymorphic: true


  scope :tags,  -> { where("context = 'tags'") }
  scope :likes, -> { where("context = 'likes'") }
  scope :hates, -> { where("context = 'hates'") }
end
