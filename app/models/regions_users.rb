class RegionsUsers < ActiveRecord::Base
  belongs_to :region_id
  belongs_to :user_id
  # attr_accessible :title, :body
end
