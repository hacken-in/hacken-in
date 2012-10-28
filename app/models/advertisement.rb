require "calendar_week"

class Advertisement < ActiveRecord::Base
  attr_accessible :calendar_week, :description, :duration, :file, :link, :context, :picture_id
  belongs_to :picture

  scope :for_actual_week, where(calendar_week: DateTime.now.iso_cweek)
  scope :context, lambda { |ctx| where(context: ctx) }
  
  class << self
  
    %w(homepage event blog_post rss podcast single_event newsletter).each do |context|
      define_method("#{context}") do
        self.for_actual_week.context(context).first || Advertisement.default
      end
    end

    def default
      self.context('default').first
    end

  end

end
