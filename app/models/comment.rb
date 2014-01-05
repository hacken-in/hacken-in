class Comment < ActiveRecord::Base
  belongs_to :commentable, polymorphic: true
  delegate :name, to: :commentable, prefix: true

  belongs_to :user
  delegate :nickname, :email, to: :user, prefix: true

  scope :recent, ->(limit=3) { order('created_at desc').limit(limit) }

  before_update :save_old_state_as_json

  attr_reader :old_state

  private

  def save_old_state_as_json
    @old_state = Comment.find(id).to_json
  end
end
