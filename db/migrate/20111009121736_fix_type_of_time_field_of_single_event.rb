class FixTypeOfTimeFieldOfSingleEvent < ActiveRecord::Migration
  def change
    change_column :single_events, :time, :datetime
  end

end
