require 'digest/md5'
require 'open-uri'

class IcalFile < ActiveRecord::Base
  def load_from_server
    @file = open(read_attribute :url).read
    @events = RiCal.parse_string(@file).first.events
  end

  def file_changed?
    if read_attribute(:md5_hash).blank?
      load_from_server
      write_attribute :md5_hash, Digest::MD5.hexdigest(@file)
      return true 
    end

    new_md5 = Digest::MD5.hexdigest(@file)

    if read_attribute(:md5_hash) == new_md5
      return false
    else
      write_attribute :md5_hash, new_md5
      return true
    end
  end

  def each_event(&block)
    @events = @events || []
    @events.each do |event|
      block.call event
    end
  end

  def each_event_with_pattern(pattern, &block)
    @events = @events || []
    @events.each do |event|
      block.call event if event.summary =~ pattern
    end
  end
end