class Comment < ActiveRecord::Base
  belongs_to :commentable, polymorphic: true
  delegate :name, to: :commentable, prefix: true

  belongs_to :user
  delegate :nickname, :email, to: :user, prefix: true

  scope :recent, lambda { |limit = 3| order('created_at desc').limit(limit) }
end
