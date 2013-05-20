class Tag < ActiveRecord::Base
  belongs_to :category

  attr_accessible :name, :category_id

  def to_param
    name
  end
end
