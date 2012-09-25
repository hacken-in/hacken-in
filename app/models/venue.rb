class Venue < ActiveRecord::Base
  attr_accessible :city, :country, :latitude, :location, :longitude, :street, :zipcode
  validates_presence_of :location
  
  has_many :events
  has_many :single_events

  after_validation :geocode

  geocoded_by :address

  default_scope order(:location)

  def address
    [self.street, "#{self.zipcode} #{self.city}"].delete_if {|d| d.blank?}.collect{|d|d.strip}.join(", ")
  end

  def to_s
  	location
  end
end
