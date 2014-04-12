class Visit < ActiveRecord::Base
  has_many :ahoy_events, class_name: "Ahoy::Event"
  belongs_to :user

  class << self
    def grouped_by_creation_day
      group_by_day(:created_at).count
    end
  end
end
