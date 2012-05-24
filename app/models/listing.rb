class Listing < ActiveRecord::Base
  attr_accessible :listing_name, :user_id, :date_and_time, :venue_name, :venue_address, :venue_url, :intention, :event_description, :ticket_option, :sell_out, :cost, :ticket_url, :sale_date
  
  belongs_to :user
  has_many :intentions, :dependent => :destroy
  
  def serializable_hash(options = null)
    options = {}
    
    options.reverse_merge!(:include => [:user, :intentions])
    
    hash = super options
    
    hash
  end
end