class Intention < ActiveRecord::Base
  attr_accessible :intent, :user_id
  
  belongs_to :user
  belongs_to :listing
end