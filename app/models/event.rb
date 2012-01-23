class Event < ActiveRecord::Base
  attr_accessible :centent
  
  belongs_to :user
end
