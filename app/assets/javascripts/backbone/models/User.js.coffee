window.User = Backbone.Model.extend
  initialize: (options) ->
    _.bindAll @
    @url = "/users/new"
  
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

window.FbUser = Backbone.Model.extend
  initialize: (options) ->
    _.bindAll @
    @url = "/friends/facebook"
  
  getName: -> @get "name"

window.FbUsers = Backbone.Collection.extend
  model: FbUser