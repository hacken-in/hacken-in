class StatisticsController < ApplicationController
  before_action :require_region!, only: [ :show ]

  def index
  end

  def show
    week_data = SingleEvent.unscoped.in_region(@current_region).where("occurrence <= ?", Date.yesterday).select("extract('dow' from occurrence) as dow, count(*)").group("extract('dow' from occurrence)")

    day_names = I18n.t(:"date.day_names").rotate

    @chart_data = day_names.map {|name| [name, 0] }

    week_data.map do |key|
      @chart_data[key.dow - 1][1] = key.count
    end
  end

end
