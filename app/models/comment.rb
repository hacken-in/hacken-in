class Comment < ActiveRecord::Base
  attr_accessible :body, :user_id, :commentable_id, :commentable_type

  belongs_to :commentable, polymorphic: true
  delegate :name, to: :commentable, prefix: true

  belongs_to :user
  delegate :nickname, :email, to: :user, prefix: true

  scope :recent, ->(limit=3) { order('created_at desc').limit(limit) }
end
