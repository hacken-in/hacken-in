class AddAdvertisementContext < ActiveRecord::Migration
  def change
    add_column :advertisements, :context, :string
  end
end
