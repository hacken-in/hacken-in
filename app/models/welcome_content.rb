class WelcomeContent < ActiveRecord::Base
  attr_accessible :box_1, :box_2, :box_3, :box_4, :box_5, :box_6, :carousel
  serialize :box_1
  serialize :box_2 
  serialize :box_3
  serialize :box_4
  serialize :box_5
  serialize :box_6
  serialize :carousel

end
