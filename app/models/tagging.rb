class Tagging < ActiveRecord::Base
  belongs_to :tag
  belongs_to :taggable, polymorphic: true

  attr_accessible :tag_id, :taggable_id, :taggable_type, :tagger_id, :tagger_type, :context

  scope :tags,  where("context = 'tags'")
  scope :likes, where("context = 'likes'")
  scope :hates, where("context = 'hates'")
end
