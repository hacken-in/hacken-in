# encoding: utf-8
class Venue < ActiveRecord::Base
  validates_presence_of :location, :city, :country, :street, :zipcode, :region_id

  has_many :events
  has_many :single_events

  belongs_to :region

  after_validation :geocode

  geocoded_by :address

  default_scope -> { order(:location) }

  def address
    [self.street, "#{self.zipcode} #{self.city}"].delete_if {|d| d.blank?}.collect{|d|d.strip}.join(", ")
  end

  def to_s
    [location, city].delete_if {|d| d.blank? }.join(", ")
  end

  def to_param
    "#{self.id} - #{self.location}"
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
