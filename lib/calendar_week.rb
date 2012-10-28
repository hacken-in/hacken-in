module IsoCweek
  # Gibt die Kalenderwoche nach der in Deutschland verbindlichen ISO 8601 zurück.
  # (KW 1 ist die Woche mit mindestens vier Tagen im neuen Jahr)
  def iso_cweek
    thursday = self.beginning_of_week + 3.days
    (thursday.yday - (Time.mktime(thursday.year, 1, 4).beginning_of_week + 3.days).yday)/ 7 + 1
  end
end

class Time
  include IsoCweek
end

class DateTime
  include IsoCweek
end
