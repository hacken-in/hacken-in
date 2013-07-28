class CreateSingleEventExternalUsers < ActiveRecord::Migration
  def change
    create_table :single_event_external_users do |t|
      t.references :single_event
      t.string :email
      t.string :name

      t.timestamps
    end
    add_index :single_event_external_users, :single_event_id
  end
end
