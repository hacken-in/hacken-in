class GoogleAnalyticsEvent
  GA_DOMAIN = "hacken.in"
  GA_UA     = "UA-40669307-2"

  class FakeConnection
    def event(*args)
      Rails.logger.info "[GABBA] Google Analytics event: #{args.inspect}"
    end
  end

  class Event
    KNOWN_EVENTS = {
      "IcalController/general"           => "iCal",
      "IcalController/personalized"      => "iCal-personalized",
      "IcalController/like_welcome_page" => "iCal-not-hated"
    }

    attr_reader :description

    def initialize(name)
      @name        = name
      @description = KNOWN_EVENTS[name]
    end

    def valid?
      @description.present?
    end

    def to_s
      @name
    end
  end

  class << self
    def track(event_name)
      event = Event.new(event_name)

      unless event.valid?
        Rails.logger.warn "[GABBA] Tried to track an unknown event: #{event.to_s}"
        return
      end

      connection.event "Event", event.description

      return event_name
    end


    private

    def connection
      @connection ||= if Rails.env.production?
                        Gabba::Gabba.new GA_UA, GA_DOMAIN
                      else
                        FakeConnection.new
                      end
    end
  end
end
