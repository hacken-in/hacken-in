module Ahoy
  class Event < ActiveRecord::Base
    self.table_name = "ahoy_events"

    belongs_to :visit
    belongs_to :user

    class << self
      def ical_by_day_and_action
        where(name: 'iCal').group("properties->>'action'").group_by_day(:time).count.map do |k,v|
          { name: k.first, data: { k.last => v } }
        end
      end
    end
  end
end
