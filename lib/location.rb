module Location

  def address
    [self.street, "#{self.zipcode} #{self.city}"].delete_if {|d| d.blank?}.collect{|d|d.strip}.join(", ")
  end

  def reset_geocode
    self.latitude = nil
    self.longitude = nil
    geocode
  end

end
