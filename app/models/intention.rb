class Intention < ActiveRecord::Base
  attr_accessible :user_id, :listing_id, :intention
  
  belongs_to :user
  belongs_to :listing
  
  def serializable_hash(options = null)
    options = {}
    
    options.reverse_merge!(:include => [:user])
    
    hash = super options
    
    hash
  end
end