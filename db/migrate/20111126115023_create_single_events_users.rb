class CreateSingleEventsUsers < ActiveRecord::Migration
  def change
    create_table :single_events_users, :id => false do |t|
      t.references :user, :single_event
    end

    add_index :single_events_users, :user_id
    add_index :single_events_users, :single_event_id
  end
end
