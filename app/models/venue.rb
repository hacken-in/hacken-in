class Venue < ActiveRecord::Base
  attr_accessible :city, :country, :latitude, :location, :longitude, :street, :zipcode
  has_many :events
  has_many :single_events

  geocoded_by :address

  def address
    [self.street, "#{self.zipcode} #{self.city}"].delete_if {|d| d.blank?}.collect{|d|d.strip}.join(", ")
  end

  def to_s
  	location
  end
end
