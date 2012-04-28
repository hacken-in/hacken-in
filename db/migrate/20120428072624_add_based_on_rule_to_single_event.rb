class AddBasedOnRuleToSingleEvent < ActiveRecord::Migration
  def change
    add_column :single_events, :based_on_rule, :boolean, default: false

  end
end
