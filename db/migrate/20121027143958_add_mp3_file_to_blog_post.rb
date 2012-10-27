class AddMp3FileToBlogPost < ActiveRecord::Migration
  def change
    add_column :blog_posts, :mp3file, :string
  end
end
