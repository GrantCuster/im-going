class Comment < ActiveRecord::Base
  attr_accessible :listing_id, :comment

  belongs_to :user
  belongs_to :listing

  def serializable_hash(options = null)
    options = {}
    
    options.reverse_merge!(:include => [:user])
    
    hash = super options
    
    hash
  end
end