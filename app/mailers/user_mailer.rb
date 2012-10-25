class UserMailer < ActionMailer::Base
  default from: "goings.im@gmail.com"
  
  def follow_notification(user, actor)
    @user = user
    @actor = actor
    @url = "http://going.im/#{actor.username}"
    mail(:to => user.email, :subject => "#{actor.username} followed you")
  end
  
  def intention_notification(user, actor, listing, intention)
    @user = user
    @actor = actor
    @actor_url = "http://going.im/#{actor.username}"
    @url = "http://going.im/listings/#{listing.id}"
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
  
  def comment_notification(user, actor, listing)
    @user = user
    @actor = actor
    @actor_url = "http://going.im/#{actor.username}"
    @listing = listing
    @url = "http://going.im/listings/#{listing.id}"
    mail(:to => user.email, :subject => "#{listing.listing_name} activity")
  end
end