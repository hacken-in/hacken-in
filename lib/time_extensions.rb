class Time
  # remove milliseconds from occurrence, this causes a bug
  # in sqlite since it uses milliseconds. Sadly the milliseconds
  # the ice_cube generates are different each self. It's the
  # current millisecond when the method is called
  # (See https://github.com/seejohnrun/ice_cube/issues/84)
  def without_ms
    Time.new self.year,
      self.month,
      self.day,
      self.hour,
      self.min,
      self.sec
  end
end
