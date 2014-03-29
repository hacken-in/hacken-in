class StatisticsController < ApplicationController
  before_action :require_region!, only: [ :show ]

  def index
  end

  def show
    week_data = SingleEvent.in_region(@current_region).where("occurrence <= ?", Date.yesterday).group("weekday(occurrence)").count

    day_names = I18n.t(:"date.day_names")

    @chart_data = week_data.keys.sort.map do |key|
      [day_names[key], week_data[key]]
    end
    # Sunday => Last day
    @chart_data.rotate
  end

end
