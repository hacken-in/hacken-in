class RemoveIcalFeature < ActiveRecord::Migration
  def up
    remove_column  :events, :ical_pattern
    remove_column  :events, :ical_file_id
    remove_column  :events, :ical_hash
    drop_table :ical_files
  end

  def down
    add_column :events, :ical_pattern, :string
    add_column  :events, :ical_file_id, :integer
    add_column  :events, :ical_hash, :string

    create_table :ical_files, force: true do |t|
      t.string "md5_hash"
      t.string "url"
      t.text   "raw"
    end
  end
end
