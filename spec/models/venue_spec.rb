#encoding: utf-8
require "spec_helper"

describe Venue do
  it "check if adress is geocoded after save" do
    venue = Venue.new
    venue.location = "Cowoco in der Gasmotorenfabrik, 3. Etage"
    venue.street = "Deutz-Mülheimerstraße 129"
    venue.city = "Köln"
    venue.zipcode = "51063"
    venue.save
    venue.latitude.should eq 50.9490279
    venue.longitude.should eq 6.986784900000001
  end

  it "check if adress is not geocoded if no adress is given" do
    venue = Venue.new
    venue.location = "Cowoco in der Gasmotorenfabrik, 3. Etage"
    venue.save
    venue.latitude.should be_nil
    venue.longitude.should be_nil
  end

  it "venue adress formatting" do
    venue = Venue.new
    venue.location = "Cowoco in der Gasmotorenfabrik, 3. Etage"
    venue.street = "Deutz-Mülheimerstraße 129"
    venue.city = "Köln"
    venue.zipcode = "51063"
    venue.address.should eq "Deutz-Mülheimerstraße 129, 51063 Köln"

    venue = Venue.new
    venue.street = "Deutz-Mülheimerstraße 129"
    venue.city = "Köln"
    venue.address.should eq "Deutz-Mülheimerstraße 129, Köln"

    venue = Venue.new
    venue.street = "Deutz-Mülheimerstraße 129"
    venue.address.should eq "Deutz-Mülheimerstraße 129"

    venue = Venue.new
    venue.city = "Köln"
    venue.zipcode = "51063"
    venue.address.should eq "51063 Köln"
  end

  it "should generate string with location" do
    venue = Venue.new
    venue.location = "Cowoco in der Gasmotorenfabrik, 3. Etage"
    venue.to_s.should == "Cowoco in der Gasmotorenfabrik, 3. Etage"
  end

  it "should generate opengraph data for a venue" do
    venue = Venue.new
    venue.location = "Cowoco in der Gasmotorenfabrik, 3. Etage"
    venue.street = "Deutz-Mülheimerstraße 129"
    venue.city = "Köln"
    venue.zipcode = "51063"
    venue.latitude = 50.9490279
    venue.longitude =  6.986784900000001
    venue.country = "Deutschland"
    venue.to_opengraph.should == {"og:latitude"=>50.9490279, "og:longitude"=>6.986784900000001,
      "og:locality"=>"Cowoco in der Gasmotorenfabrik, 3. Etage", "og:postal-code"=>"51063",
      "og:street-address"=>"Deutz-Mülheimerstraße 129", "og:country-name"=>"Deutschland"}
  end
end
