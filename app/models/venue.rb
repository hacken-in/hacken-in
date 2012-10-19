# encoding: utf-8
class Venue < ActiveRecord::Base
  attr_accessible :city, :country, :latitude, :location, :longitude, :street, :zipcode
  validates_presence_of :location, :city, :country, :street, :zipcode

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

  def to_opengraph
    {
      "og:latitude"=>latitude,
      "og:longitude"=>longitude,
      "og:locality"=>location,
      "og:postal-code"=>zipcode,
      "og:street-address"=>street,
      "og:country-name"=>country
    }
  end
end
