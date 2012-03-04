window.Listing = Backbone.Model.extend
  initialize: (options) ->
    @urlRoot = '/listings/new'

  getID: -> @get "user_id"
  getName: -> @get "listing_name"
  getUser: -> new User (@get "user")

window.Listings = Backbone.Collection.extend
  model: Listing

  initialize: ->