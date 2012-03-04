#= require_self
#= require_tree ../templates
#= require_tree ./models
#= require_tree ./views
#= require_tree ./routers

window.ImGoing =
  Models: {}
  Collections: {}
  Routers: {}
  Views: {}
  init: ->
    new ApplicationRouter
    Backbone.history.start()

$(document).ready ->
  ImGoing.init()