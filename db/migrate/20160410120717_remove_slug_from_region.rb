class RemoveSlugFromRegion < ActiveRecord::Migration
  def change
    remove_column :regions, :slug, :string
  end
end
