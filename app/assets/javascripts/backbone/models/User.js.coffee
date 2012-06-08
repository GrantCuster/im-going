window.User = Backbone.Model.extend
  urlRoot: "/users"

  initialize: (options) ->
    _.bindAll @
  
  getEmail: -> @get "email"
  getName: -> @get "username"
  getId: -> @get "id"
  getImageURL: -> 
    if @get 'image'
      square = @get "image"
      large = square.replace 'square','large'
      large
  getDescription: -> @get "description"
  getFbId: -> @get "fb_id"
  getFbToken: -> @get "fb_token"
  getFollowStatus: -> @get "followed_by_current_user"

window.Users = Backbone.Collection.extend
  model: User
  url: "/users"