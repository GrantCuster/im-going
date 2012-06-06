window.Relationship = Backbone.Model.extend
  
  url: -> 
    console.log 'url fire'
    followed_id = @get "followed_id"
    url = "/user/#{followed_id}/follow"
  
  getFollower: ->
    new User @get "follower_id"

  getFollowed: ->
    new User @get "followed_id"

window.Relationships = window.CollectionMore.extend
  model: Relationship