class Listing < ActiveRecord::Base
  attr_accessible :listing_name, :user_id, :date_and_time, :venue_name, :venue_address, :venue_url, :intention, :event_description, :ticket_option, :sell_out, :cost, :ticket_url, :sale_date, :lat, :lng, :privacy
  
  belongs_to :user
  has_many :intentions, :dependent => :destroy
  has_many :comments, :dependent => :destroy
  
  def serializable_hash(options = null)
    options = {}
    
    options.reverse_merge!(:include => [:user, :intentions, :comments])
    
    hash = super options
    
    hash
  end
  
  def self.share_message(listing)
    if listing.intention == 0
      going = "I am going to "
    elsif listing.intention == 1
      going = "I am thinking about going to "
    else
      going = "I would go, if somebody else does, to "
    end
    listing_name = listing.listing_name
    id = listing.id
    url = "http://going.im/listings/#{id}"
    text = going + listing_name + ": " + url
    text
  end
  
  # Create list of people to be notified (intented or commentted)
  def self.notify_list(listing)
    creator = User.find(listing.user_id)
    intented = Intention.where("listing_id = :listing_id", listing_id: listing.id)
    commented = Comment.where("listing_id = :listing_id", listing_id: listing.id)
    list = [creator]
    intented.each do |intention|
      if intention.user_id != listing.user_id
        userFromIntent = User.find(intention.user_id)
        list.push userFromIntent
      end
    end
    commented.each do |comment|
      if comment.user_id != listing.user_id
        userFromComment = User.find(comment.user_id)
        list.push userFromComment
      end
    end
    list
  end
  
  def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships
                        WHERE follower_id = :user_id"
    listings = where("user_id IN (#{followed_user_ids}) OR user_id = :user_id", user_id: user.id)
    listing_ids = listings.map(&:id)
    intentions = Intention.where("user_id IN (#{followed_user_ids}) OR user_id = :user_id", user_id: user.id)
    intentions.each do |intention|
      listFromIntent = Listing.find(intention.listing_id)
      unless listing_ids.include?(listinFromIntent.id)
        listings.push listFromIntent
      end
    end
    listings
  end
end