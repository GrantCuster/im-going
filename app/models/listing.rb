class Listing < ActiveRecord::Base
  attr_accessible :listing_name, :user_id, :date_and_time, :venue_name, :venue_address, :venue_url, :intention, :event_description, :ticket_option, :sell_out, :cost, :ticket_url, :sale_date, :lat, :lng, :privacy
  
  belongs_to :user
  has_many :intentions, :dependent => :destroy
  
  def serializable_hash(options = null)
    options = {}
    
    options.reverse_merge!(:include => [:user, :intentions])
    
    hash = super options
    
    hash
  end
  
  def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships
                        WHERE follower_id = :user_id"
    listings = where("user_id IN (#{followed_user_ids}) OR user_id = :user_id", user_id: user.id)
    intentions = Intention.where("user_id = :user_id", user_id: user.id)
    intentions.each do |intention|
      listFromIntent = Listing.find(intention.listing_id)
      listings.push listFromIntent
    end
    listings
  end
end