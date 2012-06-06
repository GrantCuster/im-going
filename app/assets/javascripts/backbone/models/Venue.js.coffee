window.Venue = Backbone.Model.extend
  initialize: (options) ->
    _.bindAll @
    @url = "/venues"
  
  getName: -> @get "venue_name"

window.Venues = Backbone.Collection.extend
  model: Venue