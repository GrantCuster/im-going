class UserMailer < ActionMailer::Base
  default from: "goings.im@gmail.com"
  
  def follow_notification(user)
    @user = user
    @url = "http//going.im/#{user.username}"
    mail(:to => user.email, :subject => "#{user.username} followed you")
  end
  
  def intention_notification(user, listing, intention)
    @user = user
    @user_url = "http//going.im/#{user.username}"
    @url = "http//going.im/listings/#{listing.id}"
    @listing = listing
    @intention = 
      if intention.intention == 1
        "is going to"
      elsif intention.intention == 2
        "is thinking about going to"
      else
        "would go, if somebody else does, to"
      end
    mail(:to => user.email, :subject => "#{listing.listing_name} activity")
  end
  
  def comment_notification(user, listing)
    @user = user
    @user_url = "http//going.im/#{user.username}"
    @listing = listing
    @url = "http//going.im/listings/#{listing.id}"
    mail(:to => user.email, :subject => "#{listing.listing_name} activity")
  end
end