class Region < ActiveRecord::Base
  attr_accessible :latitude, :longitude, :name, :perimeter, :slug
end
