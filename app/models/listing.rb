class Listing < ActiveRecord::Base
attr_accessible :listing_name
  
  belongs_to :user
  
  def serializable_hash(options = null)
    options = {}
    
    options.reverse_merge!(:include => [:user])
    
    hash = super options
    
    hash[:id] = id
    hash[:listing_name] = listing_name
    
    hash
  end
end