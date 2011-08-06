module DatetimeParser

  def parse_datetime_select(param, prefix)
    Time.new(param["#{prefix}(1i)"].to_i,
             param["#{prefix}(2i)"].to_i,
             param["#{prefix}(3i)"].to_i,
             param["#{prefix}(4i)"].to_i,
             param["#{prefix}(5i)"].to_i)
  end

end

