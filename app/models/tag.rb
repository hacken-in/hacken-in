class Tag < ActiveRecord::Base
  belongs_to :category
  def to_param
    name
  end 
end
