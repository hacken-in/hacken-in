if Rails.env.test?
  Geocoder::Configuration.lookup = :yahoo
  Geocoder::Configuration.api_key = "FZGMCffV34GyRHDpvcpT8NrASJtqaZ5_mdzn0gL5tAFGQg8Rv7Mgi5fkWHWyRgDU7A"
end