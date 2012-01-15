class AddMiscellaneousIndices < ActiveRecord::Migration
  def change
    add_index :comments, :user_id
    add_index :single_events, :event_id
    add_index :taggings, [:tagger_id, :tagger_type]
  end
end
