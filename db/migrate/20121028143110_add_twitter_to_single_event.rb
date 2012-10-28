class AddTwitterToSingleEvent < ActiveRecord::Migration
  def change
    add_column :single_events, :twitter, :string
  end
end
