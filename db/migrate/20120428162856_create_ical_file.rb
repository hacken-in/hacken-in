class CreateIcalFile < ActiveRecord::Migration
  def change
    create_table :ical_files do |t|
      t.string :md5_hash
      t.string :url
    end
  end
end
