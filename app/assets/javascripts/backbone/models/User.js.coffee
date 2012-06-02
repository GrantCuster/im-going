window.User = Backbone.Model.extend
  initialize: (options) ->
    _.bindAll @
    @url = "/users/new"
  
  getEmail: -> @get "email"
  getName: -> @get "username"
  getId: -> @get "id"
  getImageURL: -> 
    square = @get "image"
    large = square.replace 'square','large'
    large
  getDescription: -> @get "description"