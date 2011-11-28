class AddTwitterHashtagToSingleEvent < ActiveRecord::Migration
  def change
    add_column :single_events, :twitter_hashtag, :string
  end
end
