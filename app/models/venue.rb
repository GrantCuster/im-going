class Venue < ActiveRecord::Base
  attr_accessible :venue_name, :venue_address, :venue_url, :user_id
  
  belongs_to :user

end