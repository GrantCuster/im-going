class ImGoing.Routers.ApplicationRouter extends Backbone.Router
  initialize: (options) ->
    options ||= []
    @events = new ImGoing.Collections.EventsCollection()
    @events.reset options.events

  routes:
    "" : "index"

  index: ->
    sign_options = new ImGoing.Views.SignOptionsView
    ($ ".sign_options").html sign_options.render().el