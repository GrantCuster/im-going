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
    window.router = new ApplicationRouter()
    Backbone.history.start({pushState: true})

$(document).ready ->
  ImGoing.init()
  main_size = ->
    main_width = $(window).width() - 361
    ($ '#main_column').width main_width
    ($ '.bottom_dot').width(main_width - 152)
  main_size()
  ($ window).resize ->
    main_size()
  
Backbone.Model.prototype.toJSON = ->
  return _(_.clone(this.attributes)).extend
    'authenticity_token' : $('meta[name="csrf-token"]').attr('content')