window.Relationship = Backbone.Model.extend
  
  url: -> 
    followed_id = @get "followed_id"
    url = "/users/#{followed_id}/follow"
  
  getFollower: ->
    new User @get "follower_id"

  getFollowed: ->
    new User @get "followed_id"

window.Relationships = Backbone.Collection.extend
  model: Relationship