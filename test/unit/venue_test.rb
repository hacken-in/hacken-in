#encoding: utf-8
require 'test_helper'

class VenueTest < ActiveSupport::TestCase


  test "check if adress is geocoded after save" do
    venue = Venue.new
    venue.location = "Cowoco in der Gasmotorenfabrik, 3. Etage"
    venue.street = "Deutz-Mülheimerstraße 129"
    venue.city = "Köln"
    venue.zipcode = "51063"
    venue.save

    assert_not_nil venue.latitude
    assert_not_nil venue.longitude
  end

  test "check if adress is not geocoded if no adress is given" do
    venue = Venue.new
    venue.location = "Cowoco in der Gasmotorenfabrik, 3. Etage"
    venue.save
    assert_nil venue.latitude
    assert_nil venue.longitude
  end

  test "venue adress formatting" do
    venue = Venue.new
    venue.location = "Cowoco in der Gasmotorenfabrik, 3. Etage"
    venue.street = "Deutz-Mülheimerstraße 129"
    venue.city = "Köln"
    venue.zipcode = "51063"
    assert_equal "Deutz-Mülheimerstraße 129, 51063 Köln", venue.address

    venue = Venue.new
    venue.street = "Deutz-Mülheimerstraße 129"
    venue.city = "Köln"
    assert_equal "Deutz-Mülheimerstraße 129, Köln", venue.address

    venue = Venue.new
    venue.street = "Deutz-Mülheimerstraße 129"
    assert_equal "Deutz-Mülheimerstraße 129", venue.address

    venue = Venue.new
    venue.city = "Köln"
    venue.zipcode = "51063"
    assert_equal "51063 Köln", venue.address
  end

end
