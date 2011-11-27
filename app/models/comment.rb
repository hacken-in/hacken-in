class Comment < ActiveRecord::Base
  belongs_to :commentable, :polymorphic => true
  belongs_to :user
  
  scope :recent, lambda { |limit = 3| order('created_at desc').limit(limit) }
end
