window.User = Backbone.Model.extend

  initialize: (options) ->
    _.bindAll @
    @url = "/users/new"
  
  getEmail: -> @get "email"
  getName: -> @get "username"