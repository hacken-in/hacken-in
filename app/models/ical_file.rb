require 'digest/md5'
require 'open-uri'

class IcalFile < ActiveRecord::Base
  has_many :events

  def load_from_server
    write_attribute :raw, open(read_attribute :url).read
  end

  def md5_hash
    Digest::MD5.hexdigest read_attribute(:raw)
  end

  def each_event(pattern, &block)
    unless read_attribute(:raw).blank?
      events = RiCal.parse_string(read_attribute :raw).first.events
      events.each do |event|
        if pattern == nil || event.summary =~ /#{pattern}/
          block.call event
        end
      end
    end
  end
end