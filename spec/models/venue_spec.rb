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
    expect(venue.latitude).to eq 50.9490279
    expect(venue.longitude).to eq 6.986784900000001
  end

  it "check if adress is not geocoded if no adress is given" do
    venue = Venue.new
    venue.location = "Cowoco in der Gasmotorenfabrik, 3. Etage"
    venue.save
    expect(venue.latitude).to be_nil
    expect(venue.longitude).to be_nil
  end

  it "venue adress formatting" do
    venue = Venue.new
    venue.location = "Cowoco in der Gasmotorenfabrik, 3. Etage"
    venue.street = "Deutz-Mülheimerstraße 129"
    venue.city = "Köln"
    venue.zipcode = "51063"
    expect(venue.address).to eq "Deutz-Mülheimerstraße 129, 51063 Köln"

    venue = Venue.new
    venue.street = "Deutz-Mülheimerstraße 129"
    venue.city = "Köln"
    expect(venue.address).to eq "Deutz-Mülheimerstraße 129, Köln"

    venue = Venue.new
    venue.street = "Deutz-Mülheimerstraße 129"
    expect(venue.address).to eq "Deutz-Mülheimerstraße 129"

    venue = Venue.new
    venue.city = "Köln"
    venue.zipcode = "51063"
    expect(venue.address).to eq "51063 Köln"
  end

  it "should generate string with location" do
    venue = Venue.new
    venue.location = "Cowoco in der Gasmotorenfabrik, 3. Etage"
    expect(venue.to_s).to eq("Cowoco in der Gasmotorenfabrik, 3. Etage")
  end

  it "should generate string with location and city" do
    venue = Venue.new
    venue.location = "Cowoco in der Gasmotorenfabrik, 3. Etage"
    venue.city = "Köln"
    expect(venue.to_s).to eq("Cowoco in der Gasmotorenfabrik, 3. Etage, Köln")
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
    expect(venue.to_opengraph).to eq({"og:latitude"=>50.9490279, "og:longitude"=>6.986784900000001,
      "og:locality"=>"Cowoco in der Gasmotorenfabrik, 3. Etage", "og:postal-code"=>"51063",
      "og:street-address"=>"Deutz-Mülheimerstraße 129", "og:country-name"=>"Deutschland"})
  end
end
