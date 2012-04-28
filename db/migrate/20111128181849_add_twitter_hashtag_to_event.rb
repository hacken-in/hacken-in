class AddTwitterHashtagToEvent < ActiveRecord::Migration
  def change
    add_column :events, :twitter_hashtag, :string
  end
end
